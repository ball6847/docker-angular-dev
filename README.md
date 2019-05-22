Docker Image for Angular Development
====================================

```sh
docker build -t ball6847/angular-dev-base .
docker container run --rm -it -p 4200:4200 ball6847/angular-dev-base
```

Then go to http://localhost:4200


```
INSIDER_COMMIT=4ca38ce5584d7cd67b435b3c32ef1240c6a29628
mkdir -p /root/.vscode-remote/bin/code-insiders
cd /root/.vscode-remote/bin/code-insiders
wget -nv -O vscode-server-linux-x64.tar.gz https://update.code.visualstudio.com/commit:$INSIDER_COMMIT/server-linux-x64/insider
tar -xzf insider --strip-components 1
rm -rf insider
/root/.vscode-remote/bin/code-insiders/server.sh  --install-extension angular.ng-template --install-extension ms-vscode.vscode-typescript-tslint-plugin --install-extension esbenp.prettier-vscode --force
```
