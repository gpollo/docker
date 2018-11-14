FROM java:8-jre

ENV MINECRAFT_VERSION="1.12.2"
ENV FORGE_BUILD="14.23.5.2772"
ENV FORGE_VERSION="${MINECRAFT_VERSION}-${FORGE_BUILD}"
ENV FORGE_INSTALLER="forge-${FORGE_VERSION}-installer.jar"
ENV FORGE_WEBSITE="https://files.minecraftforge.net/maven/net/minecraftforge/forge"
ENV FORGE_LINK="${FORGE_WEBSITE}/${FORGE_VERSION}/${FORGE_INSTALLER}"
ENV FORGE_SERVER="forge-${FORGE_VERSION}-universal.jar"

WORKDIR "/minecraft"

RUN wget "${FORGE_LINK}"

RUN java -jar "${FORGE_INSTALLER}" --installServer

RUN groupadd -r minecraft \
 && useradd -r -g minecraft -d "/minecraft" -s "/bin/sh" minecraft

COPY "entrypoint.sh" "/"
ENTRYPOINT ["/entrypoint.sh", "system"]
