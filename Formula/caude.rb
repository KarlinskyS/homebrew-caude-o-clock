class Caude < Formula
  desc "Menu bar app showing Claude Code's 5-hour/weekly usage windows"
  homepage "https://github.com/KarlinskyS/caude-o-clock"
  url "https://github.com/KarlinskyS/caude-o-clock.git", tag: "v1.0.1", revision: "74a8cc84270c61e8c38d4540b66493a4c20914b7", using: :git

  depends_on "python@3.12"
  depends_on :macos

  def install
    libexec.install Dir["*.py"]
    libexec.install "assets"
    libexec.install "requirements.txt"
    libexec.install "caude"

    system Formula["python@3.12"].opt_bin/"python3.12", "-m", "venv", libexec/".venv"
    system libexec/".venv/bin/pip", "install", "--quiet", "-r", libexec/"requirements.txt"

    (bin/"caude").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/caude" "$@"
    EOS
    (bin/"caude").chmod 0755
  end

  test do
    assert_predicate libexec/".venv/bin/python3", :exist?
    assert_predicate libexec/"ccusagebar.py", :exist?
    system bin/"caude", "--help"
  end
end
