# Emacs Souls

Emacs Souls (or Souls) is a tutorial game.

## Requirements

#### Base Requirements
- Emacs 28.1 or higher

#### Multiplayer Requirements
- internet
- git v2

## Installation

Souls makes extensive modifications to Emacs's core functionalities[^1]. As such, it
is unsuitable for use within your main Emacs environment. For Souls to properly run, it must first be bootstrapped into a separate, distinct environment.

It is highly suggested to run Emacs Souls using a `user-emacs-directory` and
`user-init-file` different from those in your main environment.

(QUESTION: or maybe not? look into using a separate frame. although I'm pretty
sure a separate frame uses the same environment as its parent...)

There are two ways to bootstrap Souls.

### Bootstrapping within Emacs

The Souls package, available on MELPA, comes with a convenience script that you can run within your main Emacs environment.

To reiterate, Souls should **not** be run inside your main Emacs environment.

### Manual Bootstrapping

If you are running Emacs version 28.1, you can load a specific init file like so:
```sh
emacs --no-init-file
```

If you are running Emacs version 29 or higher, you can specify an init directory by passing the `--init-directory` flag along with the directory filename. For example:
```sh
emacs --init-directory=~/.config/emacs-souls/
```

## Bootstrapping within Emacs

TODO
