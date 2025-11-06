USB Core Example
================

The USB full-speed device core is available in
`IHP-Open-DesignLib/LibreLane/usb <https://github.com/IHP-GmbH/IHP-Open-DesignLib>`_. This
medium-sized design validates clock tree synthesis and routing on SG13G2.

Prepare the design
------------------

.. code-block:: shell

   cd $HOME/workspace/librelane-demo
   mkdir -p designs
   cp -R $IHP_OPEN_DESIGNLIB_ROOT/LibreLane/usb designs/usb

Run the flow
------------

.. code-block:: shell

   nix run .#run-suite -- usb

The default configuration targets a 20 ns clock period. Review
``01-verilator-lint/verilator-lint.log`` for warnings and document any outstanding items in
your run notes.

Next steps
----------

- Compare the generated metrics with the values recorded in
  `LibreLane/usb/val/README.md`.
- Run the SG13G2 KLayout deck if you need full-deck DRC coverage.
