package main

import (
	"fmt"
	"os"
	"os/exec"
	"time"

	"github.com/akamensky/argparse"
)

func generate_certificate(domain string, email string, dryrun bool) {
	args := []string{"certonly", "-n", "--standalone", "--agree-tos"}
	args = append(args, []string{"--preferred-challenges", "http"}...)
	args = append(args, []string{"--rsa-key-size", "4096"}...)
	args = append(args, []string{"--email", email}...)
	args = append(args, []string{"--domain", domain}...)

	if dryrun {
		args = append(args, "--dry-run")
	}

	out, err := exec.Command("certbot", args...).CombinedOutput()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	fmt.Printf("%s", out)
}

func run(domains []string, email string, dryrun bool) {
	for {
		for _, domain := range domains {
			fmt.Printf("\n=> generating for domain %s\n\n", domain)
			generate_certificate(domain, email, dryrun)
		}

		fmt.Printf("\n=> Waiting a day\n\n")
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
