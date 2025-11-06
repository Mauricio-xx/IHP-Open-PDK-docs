LibreLane PDK Setup
===================

This guide prepares the IHP SG13G2 PDK for LibreLane. The commands assume
``$USER`` expands to your login and place the PDK under ``/home/$USER/pdk``.

1. Choose a location
--------------------

Create a dedicated directory for PDK assets:

.. code-block:: shell

   mkdir -p /home/$USER/pdk
   cd /home/$USER/pdk

2. Clone the PDK repository
---------------------------

Fetch the official repository and check out the commit used throughout this documentation.

.. code-block:: shell

   git clone https://github.com/IHP-GmbH/IHP-Open-PDK
   cd IHP-Open-PDK
   git checkout 5fb50772cfe7c957a49eadb80c25aae3def38fe0

3. Set ``PDK_ROOT`` permanently
-------------------------------

Add the environment variable to your shell profile so every session picks up the same
location. For Bash and compatible shells:

.. code-block:: shell

   echo 'export PDK_ROOT=/home/$USER/pdk/IHP-Open-PDK' >> ~/.bashrc
   source ~/.bashrc

To verify, open a new shell and run ``echo $PDK_ROOT``. The value should point to the path
above without requiring additional exports.

.. warning::
   LibreLane will fail with ``PDK_ROOT not set`` if this variable is not exported correctly.
   Always verify in a fresh shell before proceeding to the tool setup step.

4. Optional: share the PDK across tools
---------------------------------------

If other flows (OpenROAD, etc.) also use SG13G2, point them to the same
``PDK_ROOT``. Keeping a single checkout avoids version skew between toolchains.

Next steps
----------

Proceed to :doc:`tool_setup` to install LibreLane and stage the example designs.
