package main

import (
	"fmt"
	"os"
	"os/exec"
	"regexp"
	"time"

	"github.com/akamensky/argparse"
)

func generate_pkcs12(domain string, dryrun bool) {
	password := os.Getenv("PKCS12_PASSWORD")
	if dryrun || password == "" {
		fmt.Println("no PKCS12 certificate generated")
		return
	}

	certs := "/etc/letsencrypt/live/" + domain
	args := []string{"pkcs12", "-export"}
	args = append(args, []string{"-out", certs + "/certificate.p12"}...)
	args = append(args, []string{"-inkey", certs + "/privkey.pem"}...)
	args = append(args, []string{"-in", certs + "/cert.pem"}...)
	args = append(args, []string{"-certfile", certs + "/chain.pem"}...)
	args = append(args, []string{"-password", "pass:" + password}...)

	output, err := exec.Command("openssl", args...).CombinedOutput()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	fmt.Printf("%s", output)
}

func generate_certificate(domain string, email string, dryrun bool) bool {
	args := []string{"certonly", "-n", "--standalone", "--agree-tos"}
	args = append(args, []string{"--preferred-challenges", "http"}...)
	args = append(args, []string{"--rsa-key-size", "4096"}...)
	args = append(args, []string{"--email", email}...)
	args = append(args, []string{"--domain", domain}...)

	if dryrun {
		args = append(args, "--dry-run")
	}

	output, err := exec.Command("certbot", args...).CombinedOutput()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	fmt.Printf("%s", output)

	matched, err := regexp.Match("not yet due for renewal", output)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	return !matched
}

func run(domains []string, email string, dryrun bool) {
	for {
		for _, domain := range domains {
			fmt.Printf("\n=> generating for domain %s\n\n", domain)
			renewed := generate_certificate(domain, email, dryrun)

			if !renewed {
				continue
			}

			fmt.Printf("\n=> generating PKCS12 for domain %s\n\n", domain)
			generate_pkcs12(domain, dryrun)
		}

		fmt.Printf("\n=> waiting a day\n\n")
		time.Sleep(24 * time.Hour)
	}
}

func main() {
	parser := argparse.NewParser("certbotw", "Simple wrapper around certbot")

	domains := parser.StringList("d", "domain", &argparse.Options{
		Required: true,
		Help:     "Generate a certificate for this domain",
	})

	email := parser.String("e", "email", &argparse.Options{
		Required: true,
		Help:     "Generate the certificates for this email",
	})

	dryrun := parser.Flag("s", "staging", &argparse.Options{
		Required: false,
		Default:  false,
		Help:     "Don't generate the certificates",
	})

	err := parser.Parse(os.Args)
	if err != nil {
		fmt.Print(parser.Usage(err))
		os.Exit(1)
	}

	run(*domains, *email, *dryrun)
}
