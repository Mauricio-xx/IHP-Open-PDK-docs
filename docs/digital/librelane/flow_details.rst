LibreLane RTL-to-GDS Flow Details
=================================

This document follows the LibreLane pipeline used to sign off the examples in this guide
with the IHP SG13G2 PDK commit ``5fb50772cfe7c957a49eadb80c25aae3def38fe0``. It explains
how to launch the flow, monitor its stages, and validate the resulting layout. The RTL and
configuration files for the featured designs (`usb`, `BM64`, `picorv32a`) live in the
`IHP-Open-DesignLib <https://github.com/IHP-GmbH/IHP-Open-DesignLib>`_ repository under
``LibreLane/<design>/design_data/librelane/``.

Entry points
------------

Use either of the commands below from a shell where the LibreLane flake is available.

.. code-block:: shell

   cd $HOME/workspace/librelane-demo/librelane
   nix run .#run-suite -- inverter usb

   # or, once inside `nix develop`
   ./scripts/run_suite.sh inverter usb

Both commands resolve each argument to ``designs/<design>/config.json`` and execute::

   librelane --run-tag "$RUN_TAG" \
     --pdk "$PDK" --scl "$STD_CELL_LIBRARY" --pdk-root "$PDK_ROOT" --condensed \
     <config.json>

Set ``RUN_TAG`` explicitly when you need deterministic output directories.

Stage sequence and artefacts
----------------------------

The ``meta.flow`` array in every ``config.json`` lists the stages. The run directory mirrors
that order; the table below links stage names to their artefacts.

.. list-table::
   :header-rows: 1
   :widths: 25 35 40

   * - Stage
     - Directory prefix
     - Primary artefacts to review
   * - ``Yosys.Synthesis``
     - ``01-yosys-synthesis``
     - ``synthesis.log``, ``synth_stat.json``
   * - ``OpenROAD.Floorplan``
     - ``04-openroad-floorplan``
     - ``floorplan.def`` (die size, tap placement)
   * - ``OpenROAD.GeneratePDN``
     - ``05-openroad-pdn``
     - ``pdn.log``, ``pdn.cfg`` (stripe pitch and offsets)
   * - ``OpenROAD.GlobalPlacement``
     - ``07-openroad-global-placement``
     - ``route_guide.def`` (placement density, congestion)
   * - ``OpenROAD.DetailedRouting``
     - ``10-openroad-detailed-routing``
     - ``route.log``, ``antenna.rpt``
   * - ``Magic.StreamOut``
     - ``12-magic-stream-out``
     - ``gds/<design>.gds``
   * - ``Checker.MagicDRC``
     - ``13-magic-drc``
     - ``magic_drc.log`` (expect zero errors)
   * - ``Checker.LVS``
     - ``15-netgen-lvs``
     - ``netgen.log`` (expect "Circuits match")

Metrics extraction
------------------

After a successful run, capture the aggregated metrics for review and regression tracking.

.. code-block:: shell

   librelane.state latest designs/inverter/runs/$RUN_TAG \
     --extract-metrics-to designs/inverter/runs/$RUN_TAG/final/metrics.json
   jq '.' designs/inverter/runs/$RUN_TAG/final/metrics.json

The JSON file records timing, area, power, and DRC status. Save it with your run logs.

Example runs
------------

Simple smoke test
   ``inverter`` validates the toolchain in under 2 minutes::

       nix run .#run-suite -- inverter

Medium design
   ``usb`` stresses clock tree synthesis and routing. Expect 5–10 minutes::

       nix run .#run-suite -- usb

Large design
   ``BM64`` represents a complex datapath. Copy it from
   ``IHP-Open-DesignLib/LibreLane/BM64`` and run (10–15 minutes)::

       nix run .#run-suite -- BM64

   ``picorv32a`` is the largest example (~46k instances). Runtime can exceed 30 minutes
   depending on your hardware.

When iterating on a single stage, set ``LIBRELANE_EXTRA_ARGS`` so LibreLane stops early and
you can inspect intermediate results.

Full-deck DRC validation
------------------------

LibreLane runs Magic DRC and Netgen LVS automatically. For the full SG13G2 release deck,
reuse the KLayout script included in the PDK.

.. code-block:: shell

   export DESIGN_ROOT=$HOME/workspace/librelane-demo/designs
   python3 $PDK_ROOT/ihp-sg13g2/libs.tech/klayout/tech/drc/run_drc.py \
     --path $DESIGN_ROOT/inverter/runs/$RUN_TAG/final/gds/inverter.gds \
     --run_dir $DESIGN_ROOT/inverter/runs/$RUN_TAG/final/drc-klayout

Inspect ``summary.xml`` and ``run.log`` in ``drc-klayout`` before signing off the run.

Housekeeping
------------

- Run directories under ``designs/<design>/runs/<tag>/`` grow quickly; exclude them from
  version control and archive only the reports you need.
- Use consistent ``RUN_TAG`` strings (for example ``ihp-sg13g2-20251103-120500``) so other
  contributors can reproduce your results.

Next steps
----------

Move on to :doc:`examples/inverter` for a step-by-step reproduction of the inverter run,
then apply the same checklist to more complex SG13G2 designs.
