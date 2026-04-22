#!/bin/bash
set -e

RUNNER_VERSION="2.333.1"
RUNNER_HASH="18f8f68ed1892854ff2ab1bab4fcaa2f5abeedc98093b6cb13638991725cab74"
RUNNER_USER="runner"
RUNNER_DIR="/opt/actions-runner"
REPO_URL="https://github.com/StudentPP1/software-deploy-labs"

echo "[1/5] Updating system..."
apt-get update -qq
apt-get upgrade -y -qq

echo "[2/5] Installing dependencies..."
apt-get install -y -qq \
  curl \
  ca-certificates \
  git \
  jq \
  tar \
  unzip \
  openssh-client

echo "[3/5] Installing Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -qq
apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-compose-plugin

systemctl enable docker
systemctl start docker

echo "[4/5] Creating runner user and downloading runner..."
if ! id "$RUNNER_USER" &>/dev/null; then
  useradd -m -s /bin/bash "$RUNNER_USER"
fi
usermod -aG docker "$RUNNER_USER"

mkdir -p "$RUNNER_DIR"
chown "$RUNNER_USER":"$RUNNER_USER" "$RUNNER_DIR"

curl -fsSL \
  "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" \
  -o /tmp/actions-runner.tar.gz

echo "Validating hash..."
echo "${RUNNER_HASH}  /tmp/actions-runner.tar.gz" | shasum -a 256 -c

tar xzf /tmp/actions-runner.tar.gz -C "$RUNNER_DIR"
chown -R "$RUNNER_USER":"$RUNNER_USER" "$RUNNER_DIR"
rm /tmp/actions-runner.tar.gz

echo "[5/5] Installing runner dependencies..."
"$RUNNER_DIR/bin/installdependencies.sh"

echo "  1. Go to GitHub and get the token:"
echo "     $REPO_URL/settings/actions/runners/new"
echo ""
echo "  2. Run:"
echo "     cd $RUNNER_DIR"
echo "     sudo -u $RUNNER_USER ./config.sh \\"
echo "       --url $REPO_URL \\"
echo "       --token YOUR_TOKEN_HERE \\"
echo "       --name my-runner \\"
echo "       --unattended"
echo ""
echo "  3. Start as a service:"
echo "     cd $RUNNER_DIR"
echo "     sudo ./svc.sh install $RUNNER_USER"
echo "     sudo ./svc.sh start"
echo ""