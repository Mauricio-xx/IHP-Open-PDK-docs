RTL-to-GDS Examples
===================

These guides walk through complete LibreLane runs using the staged designs. Start with the
inverter if you are new to the flow, then explore the larger designs hosted in
`IHP-Open-DesignLib <https://github.com/IHP-GmbH/IHP-Open-DesignLib>`_. Additional designs
such as ``BM64`` follow the same pattern—copy the directory from the design library into
``designs/`` and invoke ``nix run .#run-suite -- <design>``.

.. toctree::
   :maxdepth: 1

   inverter
   counter
   riscv
   usb
