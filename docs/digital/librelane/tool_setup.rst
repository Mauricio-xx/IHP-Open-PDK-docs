LibreLane Toolchain Setup
=========================

This guide explains how to install LibreLane and stage the example designs once the PDK is
available. Complete :doc:`pdk_setup` first, then continue here. All steps were validated on
November 3, 2025 using the tool versions listed below.

Reference tool versions
-----------------------

- **LibreLane**: ``3.0.0.dev39`` (``librelane --version``)
- **Yosys**: ``0.54``
- **OpenROAD**: nightly build ``2025-09-01``
- **Magic**: ``8.3.528``
- **Verilator**: ``5.038``
- **KLayout**: ``0.30.2`` (Python-enabled build)
- **IHP PDK commit**: ``5fb50772cfe7c957a49eadb80c25aae3def38fe0``

If a command prints a different version, adjust your environment before continuing.

How versions are pinned
-----------------------

LibreLane relies on a Nix flake. The concrete tool versions are recorded in
``flake.lock`` inside the LibreLane repository. You can inspect the inputs at any time:

.. code-block:: shell

   cd $HOME/workspace/librelane-demo/librelane
   nix flake metadata

Look for the ``inputs`` section; it lists the exact commit and hash of `librelane`,
`nix-eda`, `nixpkgs`, and related inputs. Re-running ``nix develop`` pulls the versions
specified in that lock file, guaranteeing reproducibility. To update to newer toolchains,
run ``nix flake update`` (and capture the new lock file) before repeating the steps below.

1. Install Nix with flakes enabled
----------------------------------

Nix provides repeatable packages for LibreLane and the EDA stack.

.. code-block:: shell

   sh <(curl -L https://nixos.org/nix/install) --daemon
   mkdir -p ~/.config/nix
   cat <<'CFG' > ~/.config/nix/nix.conf
   experimental-features = nix-command flakes
   CFG

Open a new shell and confirm the install::

   nix --version       # expect 2.18 or newer
   nix flake --help

2. Prepare a workspace
----------------------

Pick a directory where you will stage LibreLane and the example designs. This guide uses
``$HOME/workspace/librelane-demo`` for clarity:

.. code-block:: shell

   mkdir -p $HOME/workspace/librelane-demo
   cd $HOME/workspace/librelane-demo

3. Install LibreLane
--------------------

Clone LibreLane and pin the commit that produced the versions above.

.. code-block:: shell

   git clone https://github.com/librelane/librelane
   cd librelane
   git checkout 3.0.0.dev39
   cd ..

(If the tag is updated, adapt the checkout and record ``librelane --version`` in your
notes.)

4. Enter the pinned Nix environment
-----------------------------------

LibreLane ships a flake that provisions the entire toolchain.

.. code-block:: shell

   cd $HOME/workspace/librelane-demo/librelane
   nix develop

.. note::
   The first ``nix develop`` invocation downloads and builds the complete EDA toolchain. This
   may take 15–30 minutes depending on your network speed and CPU. Subsequent invocations are
   instantaneous since Nix caches everything.

While inside the shell verify the binaries::

   librelane --version
   openroad -version
   yosys -V
   klayout -v

All commands should match the versions listed earlier. Exit the shell with ``Ctrl+D`` when
you are done.

5. Stage the example designs
----------------------------

The documentation ships a self-contained inverter example in
``docs/digital/examples/librelane``. If you have a local checkout of these docs, set a
helper variable that points to it and copy the example into your workspace. Replace the
value of ``$IHP_OPEN_PDK_DOCS_ROOT`` with your actual path.

.. code-block:: shell

   cd $HOME/workspace/librelane-demo
   mkdir -p designs
   export IHP_OPEN_PDK_DOCS_ROOT=$HOME/workspace/IHP-Open-PDK-docs  # adjust as needed
   cp -R $IHP_OPEN_PDK_DOCS_ROOT/docs/digital/examples/librelane/inverter \
         designs/inverter

If you are reading the rendered HTML and do not have a local checkout, recreate the files
by copying the code snippets in :doc:`config_reference`.

For the larger benchmarks documented in the flow guide, clone the
`IHP-Open-DesignLib <https://github.com/IHP-GmbH/IHP-Open-DesignLib>`_ repository and copy
the prepared directories::

   git clone https://github.com/IHP-GmbH/IHP-Open-DesignLib
   export IHP_OPEN_DESIGNLIB_ROOT=$HOME/workspace/IHP-Open-DesignLib
   cp -R $IHP_OPEN_DESIGNLIB_ROOT/LibreLane/usb        designs/usb
   cp -R $IHP_OPEN_DESIGNLIB_ROOT/LibreLane/BM64       designs/BM64
   cp -R $IHP_OPEN_DESIGNLIB_ROOT/LibreLane/picorv32a  designs/picorv32a

6. Export runtime variables
---------------------------

Before launching LibreLane runs, export the variables the CLI expects.

.. code-block:: shell

   export PDK_ROOT=${PDK_ROOT:-/home/$USER/pdk/IHP-Open-PDK}
   export PDK=ihp-sg13g2
   export STD_CELL_LIBRARY=sg13g2_stdcell
   export RUN_TAG=ihp-sg13g2-$(date +%Y%m%d-%H%M%S)

Optional helpers:

- ``LIBRELANE_EXTRA_ARGS`` restricts the executed stages (for example,
  ``--from Yosys.Synthesis --to OpenROAD.GlobalPlacement``).
- ``INSTALL_IP_DEPS=1`` tells the run scripts to download any required IP using
  ``ipmgr`` before launching LibreLane.

Next steps
----------

You now have a clean workspace with pinned tool versions and ready-to-run designs. Continue
with :doc:`flow_details` to execute the RTL-to-GDS pipeline, then follow
:doc:`examples/inverter` to validate the inverter example end to end.
