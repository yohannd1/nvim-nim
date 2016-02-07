from neovim import attach


def cleanup(nvim):
    nvim.command('bd!')
    nvim.command('new')


def startNvim():
    nvim = attach("socket", path="/tmp/nvim")
    cleanup(nvim)
    return nvim
