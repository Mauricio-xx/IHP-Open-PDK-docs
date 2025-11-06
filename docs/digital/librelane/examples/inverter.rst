Inverter Example
================

Follow this quickstart to take the ``inverter`` design from RTL to GDS. Complete
:doc:`../pdk_setup` and :doc:`../tool_setup` before starting.

Prerequisites
-------------

- ``PDK_ROOT`` exported (see :doc:`../pdk_setup`)
- LibreLane repository cloned and checked out at ``3.0.0.dev39``
- Nix installed with flakes enabled (``nix --version`` ≥ 2.18)
- Inverter example copied to ``$HOME/workspace/librelane-demo/designs/inverter`` (see
  :doc:`../tool_setup`)

Step 1 – Enter the pinned environment
-------------------------------------

.. code-block:: shell

   cd $HOME/workspace/librelane-demo/librelane
   nix develop

Inside the shell confirm the versions::

   librelane --version
   openroad -version
   yosys -V

Each command should match the values listed in the setup guide.

Step 2 – Export runtime variables
---------------------------------

.. code-block:: shell

   export PDK_ROOT=${PDK_ROOT:-/home/$USER/pdk/IHP-Open-PDK}
   export PDK=ihp-sg13g2
   export STD_CELL_LIBRARY=sg13g2_stdcell
   export RUN_TAG=ihp-sg13g2-$(date +%Y%m%d-%H%M%S)

(Optional) Narrow the flow window during debugging::

   export LIBRELANE_EXTRA_ARGS="--from Yosys.Synthesis --to OpenROAD.GlobalPlacement"

Step 3 – Run the inverter configuration
---------------------------------------

.. code-block:: shell

   nix run .#run-suite -- inverter

LibreLane writes artefacts to ``designs/inverter/runs/$RUN_TAG``. A successful run ends
with Magic DRC and Netgen LVS reports showing zero violations.

.. note::
   The inverter example typically completes in under 2 minutes. You will see progress messages
   for each flow stage. If a stage fails, check the corresponding log file under
   ``designs/inverter/runs/$RUN_TAG/`` for detailed error messages.

Step 4 – Collect metrics
------------------------

.. code-block:: shell

   librelane.state latest designs/inverter/runs/$RUN_TAG \
     --extract-metrics-to designs/inverter/runs/$RUN_TAG/final/metrics.json
   jq '."timing"' designs/inverter/runs/$RUN_TAG/final/metrics.json

Confirm that setup and hold violations are zero and note the reported utilisation and
wirelength for future comparisons.

Step 5 – Run the SG13G2 DRC deck
--------------------------------

.. code-block:: shell

   python3 $PDK_ROOT/ihp-sg13g2/libs.tech/klayout/tech/drc/run_drc.py \
     --path designs/inverter/runs/$RUN_TAG/final/gds/inverter.gds \
     --run_dir designs/inverter/runs/$RUN_TAG/final/drc-klayout

Review ``run.log`` and ``summary.xml`` in ``drc-klayout`` and archive them with the metrics
file.

Step 6 – Scale to larger designs
--------------------------------

Run additional configurations to validate more of the toolchain. Copy the designs from
``IHP-Open-DesignLib/LibreLane`` into your workspace as described in the setup guide
before launching the commands below.

.. code-block:: shell

   nix run .#run-suite -- usb
   nix run .#run-suite -- BM64

- ``usb`` should complete without timing violations but can emit Verilator warnings; audit
  ``01-verilator-lint/verilator-lint.log`` before sign-off.
- ``BM64`` uses relaxed timing (30 ns) and low core utilisation; confirm that the OpenROAD
  stages honour the values set in ``designs/BM64/config.json``.

Checklist before recording results
----------------------------------

- [ ] Metrics JSON stored beside the run log
- [ ] Magic DRC, Netgen LVS, and KLayout summaries archived
- [ ] Any warnings documented in review notes

After completing these steps, your workstation matches the reproducible baseline described
in this documentation and is ready for broader regression testing.
