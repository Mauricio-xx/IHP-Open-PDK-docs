LibreLane Overview
==================

LibreLane is the digital RTL-to-GDS flow referenced by this documentation. This section
summarises the designs that have been validated on the SG13G2 PDK and points to the
step-by-step guides.

Design catalog
--------------

All example designs are published in the
`IHP-Open-DesignLib <https://github.com/IHP-GmbH/IHP-Open-DesignLib>`_ repository under
``LibreLane/<design>/design_data/librelane/``.

.. list-table::
   :header-rows: 1
   :widths: 20 35 45

   * - Design
     - What it exercises
     - Flow notes
   * - ``inverter``
     - Minimal combinational RTL
     - Bundled in this repository (see :doc:`tool_setup`).
   * - ``usb``
     - USB full-speed device core
     - Larger block, no external IP required.
   * - ``BM64``
     - Booth multiplier datapath
     - Relax ``CLOCK_PERIOD`` to 30 ns for reliable STA.
   * - ``picorv32a``
     - PicoRV32 CPU (~46k instances)
     - Good stress test for placement, routing, and timing fixes.

How to use this section
-----------------------

1. Read :doc:`pdk_setup` and :doc:`tool_setup` to prepare the environment.
2. Follow :doc:`examples/inverter` to run the inverter smoke test.
3. Move on to :doc:`flow_details` for a deeper look at each flow stage.
4. Consult :doc:`config_reference` when customising configuration files.

Related tooling
---------------

LibreLane is part of a broader digital toolchain described elsewhere in this manual.
The :doc:`../openroad` section focuses on using OpenROAD directly and complements the
LibreLane material if you need lower-level control.
