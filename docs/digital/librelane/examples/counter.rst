Counter Example
===============

This design extends the inverter quickstart with a synchronous 8-bit counter. The RTL and
configuration live in ``docs/digital/examples/librelane/counter``.

Prepare the design
------------------

.. code-block:: shell

   cd $HOME/workspace/librelane-demo
   mkdir -p designs
   cp -R $IHP_OPEN_PDK_DOCS_ROOT/docs/digital/examples/librelane/counter \
         designs/counter

Run the flow
------------

.. code-block:: shell

   nix run .#run-suite -- counter

LibreLane writes artefacts to ``designs/counter/runs/$RUN_TAG``. Timing closes at
``CLOCK_PERIOD = 10`` ns with zero setup/hold violations.

Inspect results
---------------

Follow the same post-processing steps as the inverter quickstart:

- Extract metrics with ``librelane.state``.
- Review Magic DRC and Netgen LVS logs in the run directory.
- Optional: run the SG13G2 KLayout DRC deck on
  ``designs/counter/runs/$RUN_TAG/final/gds/counter.gds``.
