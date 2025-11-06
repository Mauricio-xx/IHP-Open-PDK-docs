LibreLane Configuration Guide
=============================

This reference explains how the LibreLane examples in this documentation are configured for
SG13G2. The inverter project shipped under ``docs/digital/examples/librelane`` is used as
the baseline. Larger benchmarks (`usb`, `BM64`, `picorv32a`) are published in the
`IHP-Open-DesignLib <https://github.com/IHP-GmbH/IHP-Open-DesignLib>`_ repository under
``LibreLane/<design>/design_data/librelane/``.

Configuration format
--------------------

LibreLane accepts JSON and YAML. The examples in this guide use JSON to avoid indentation
ambiguities.

Minimal structure
-----------------

.. code-block:: json
   :caption: ``designs/inverter/config.json``

   {
       "meta": {
           "version": 2,
           "flow": [
               "Yosys.Synthesis",
               "OpenROAD.CheckSDCFiles",
               "OpenROAD.Floorplan",
               "OpenROAD.TapEndcapInsertion",
               "OpenROAD.GeneratePDN",
               "OpenROAD.IOPlacement",
               "OpenROAD.GlobalPlacement",
               "OpenROAD.RepairDesign",
               "OpenROAD.DetailedPlacement",
               "OpenROAD.GlobalRouting",
               "OpenROAD.DetailedRouting",
               "OpenROAD.FillInsertion",
               "Magic.StreamOut",
               "Magic.DRC",
               "Checker.MagicDRC",
               "Magic.SpiceExtraction",
               "Netgen.LVS",
               "Checker.LVS"
           ]
       },
       "DESIGN_NAME": "inverter",
       "VERILOG_FILES": "dir::src/inverter.v",
       "CLOCK_PORT": null,
       "FP_SIZING": "absolute",
       "DIE_AREA": [0, 0, 50, 50],
       "CORE_AREA": [5, 5, 45, 45],
       "PL_TARGET_DENSITY": 0.5
   }

Key fields
----------

``meta.flow``
    Explicit list of stages. Keep it in version control so pipeline changes are obvious.

``DESIGN_NAME``
    Must match the top-level Verilog module. Case sensitive.

``VERILOG_FILES``
    Paths relative to the folder that holds ``config.json``. ``dir::`` expands to that
    folder. Avoid wildcards unless the directory contains RTL only.

``CLOCK_PORT`` and ``CLOCK_NET``
    Set both for synchronous designs. Leave ``CLOCK_PORT`` as ``null`` for purely
    combinational examples like the inverter.

``FP_SIZING`` / ``DIE_AREA`` / ``CORE_AREA``
    SG13G2 flows prefer absolute sizing. Provide explicit die and core coordinates to
    guarantee identical floorplans regardless of host machine.

PDK-specific overrides
----------------------

Add technology-specific tweaks inside blocks named ``pdk::<pattern>``. The same config file
can then target multiple PDKs.

.. code-block:: json
   :caption: Excerpt from ``LibreLane/BM64/design_data/librelane/config.json``

   {
       "DESIGN_NAME": "BM64",
       "VERILOG_FILES": "dir::src/*.v",
       "CLOCK_PORT": "Clk",
       "FP_SIZING": "absolute",
       "DIE_AREA": "0 0 1000 1000",
       "pdk::ihp-sg13g2*": {
           "CLOCK_PERIOD": 30,
           "SYNTH_MAX_FANOUT": 6,
           "FP_CORE_UTIL": 18
       }
   }

Guidelines for SG13G2 blocks

- Always provide a realistic ``CLOCK_PERIOD``. Larger benchmarks (``BM64``, ``usb``) use
  relaxed targets to pass timing on SG13G2 at commit
  ``5fb50772cfe7c957a49eadb80c25aae3def38fe0``.
- Enable antenna protection when required. For example ``usb`` enables
  ``"RUN_HEURISTIC_DIODE_INSERTION": true`` and selects ``"DIODE_CELL": "sg13g2_antennanp/A"``.
- Keep SG13G2-specific keys inside ``pdk::ihp-sg13g2*`` so the same config can run on other
  PDKs that provide their own overrides.

Diagnostics
-----------

``librelane.state``
    Run ``librelane.state latest <run-dir>`` to view the fully merged configuration and
    confirm that SG13G2 overrides were applied.

Stage logs
    LibreLane writes logs under ``designs/<name>/runs/<tag>/``. Compare ``01-verilator-lint``
    and ``04-openroad-floorplan`` against the config when debugging.

Version control practice
------------------------

- Store RTL, configuration files, and updated metrics together in the same change.
- Do not commit ``runs/`` directories; archive only the reports required for review.
- Keep example configs small so new contributors can relate options to observed flow
  behaviour.

Next steps
----------

Continue with :doc:`flow_details` to see how LibreLane executes the stages, then follow
:doc:`examples/inverter` for a reproducible inverter run before tackling larger designs.
