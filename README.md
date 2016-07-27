A pre-scripted environment for `osc/quilt` using `carltonf/obs-toolbox` docker
image.

(**WARNING:** not all features listed here have been implemented yet.)

# Basic Usage

You need have setup up docker, and pulled `carltonf/obs-toolbox` first. A
standard workflow would look like:

  ```sh
  git clone https://github.com/carltonf/obs-workspace
  cd obs-workspace
  source tools/envsetup.sh
  croot
  osc co openSUSE:Leap:42.1:Update/make
  # after package downloaded
  cd openSUSE:Leap:42.1:Update/make
  quilt setup make.spec
  # and etc.
  ```

Sourcing `tools/envsetup.sh` enables you to use various pre-scripted tools like
`osc`, `quilt`, type `help` for more info.

# Features

## tools/macros.stub

Because some RPM spec files use macros that are only specific to this package
and there is no way `obs-toolbox` can package all dependencies, a tool
`stub_rpm_macro` is provided to stub out these macros. This is mainly to avoid
macro unfound errors during `quilt setup <spec-file>`.

`list_stub_macros` can be used to list all stubbed macros.

## Support for both Bash and fish shell

**WARNING** Bash `envsetup.sh` is not implemented yet.

Bash's `evnsetup` has borrowed heavily from Android's build/envsetup. Some
functions in `fish` might be wrappers around Bash's counterparts, you need to
have fish-plugin [bass](https://github.com/edc/bass). The plan is to have fish
native functions as much as possible.

# Under the hood

Other than the `envsetup` scripts, most heavy-lifting is done by
`carltonf/obs-toolbox` image. Take a look at the
[repo](https://github.com/carltonf/dockerfiles) for the curious.
