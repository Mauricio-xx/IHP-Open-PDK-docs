RISC-V Example (picorv32a)
==========================

This example uses the `picorv32a` design published in
`IHP-Open-DesignLib/LibreLane/picorv32a <https://github.com/IHP-GmbH/IHP-Open-DesignLib>`_.
It exercises the full LibreLane flow on a ~46k instance CPU.

Prepare the design
------------------

.. code-block:: shell

   cd $HOME/workspace/librelane-demo
   mkdir -p designs
   cp -R $IHP_OPEN_DESIGNLIB_ROOT/LibreLane/picorv32a designs/picorv32a

Run the flow
------------

.. code-block:: shell

   nix run .#run-suite -- picorv32a

The run may take several minutes. Expect clean timing at the configured clock period and
zero DRC/LVS violations when using the pinned toolchain.

Post-run checklist
------------------

- Export metrics: ``librelane.state latest designs/picorv32a/runs/$RUN_TAG \
  --extract-metrics-to designs/picorv32a/runs/$RUN_TAG/final/metrics.json``.
- Review Magic DRC and Netgen LVS logs under ``designs/picorv32a/runs/$RUN_TAG``.
- Optional: run the SG13G2 KLayout deck on the generated GDS.
