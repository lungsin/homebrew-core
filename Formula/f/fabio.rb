class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/fabiolb/fabio"
  url "https://github.com/fabiolb/fabio/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "cd80ee0dedb78e865814fd0aae311546a3bbae8ef839e636049a540fbecbf99b"
  license "MIT"
  head "https://github.com/fabiolb/fabio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c60703966ecd1882b0fd0a5c0122864a26c376552b662cfb408093e3bc7a3949"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4a20558083c013910f2d092982c75243b8a358b1599fc75a1b18de6890d9526"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab8990ed9eeab8dee4b314bcb6189d50f4dc8eebee77de71bc496d4bf8c78b9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93816978aba8f3872e86a77f0ccf1965d92d7377389af58fa12a58c97f23033c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f6bbd95332e4477f3dab83ab33e4ea0eefe9a5545d24b25388e435a14a6baba"
    sha256 cellar: :any_skip_relocation, sonoma:         "e034f62a86f59035c2bf31563214cc76234336f4ee9c5d6f049f8659c1d508aa"
    sha256 cellar: :any_skip_relocation, ventura:        "f05450e71e0044473f85a289d549277edede0d51166a66ff985465f826290d6f"
    sha256 cellar: :any_skip_relocation, monterey:       "ee9fa30859ec7a0e89cd3725759d6f57d039f6a36529abaca6dea2c5d22a163a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca2de624dcf98c51943d3968c19bbf6fd5e4211826b29eadff3a9bde4d4ace45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee9395e3877ab2abdaa6dddba8405241ca30ce5c0ae56eada5b01e15cdb37382"
  end

  depends_on "go" => :build
  depends_on "etcd" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  def port_open?(ip_address, port, seconds = 1)
    Timeout.timeout(seconds) do
      TCPSocket.new(ip_address, port).close
    end
    true
  rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Timeout::Error
    false
  end

  test do
    require "socket"
    require "timeout"

    fabio_default_port = 9999
    localhost_ip = "127.0.0.1".freeze

    pid_etcd = spawn "etcd", "--advertise-client-urls", "http://127.0.0.1:2379",
                             "--listen-client-urls", "http://127.0.0.1:2379"
    sleep 10

    system "etcdctl", "--endpoints=http://127.0.0.1:2379", "put", "/fabio/config", ""

    (testpath/"fabio.properties").write <<~EOS
      registry.backend=custom
      registry.custom.host=127.0.0.1:2379
      registry.custom.scheme=http
      registry.custom.path=/fabio/config
      registry.custom.timeout=5s
      registry.custom.pollinterval=10s
    EOS

    pid_fabio = spawn bin/"fabio", "-cfg", testpath/"fabio.properties"
    sleep 10

    assert_equal true, port_open?(localhost_ip, fabio_default_port)
  ensure
    Process.kill("TERM", pid_etcd)
    Process.kill("TERM", pid_fabio)
    Process.wait(pid_etcd)
    Process.wait(pid_fabio)
  end
end
