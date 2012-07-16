JUNOS defaults to SONET framing for all SDH interfaces (so-x/y/z).
This simple scripts toggles this behavior and configures SDH framing for each
so- interface that is configured on the system.

Non-configured _and_ present interfaces will still use the default framing, until
they're mentioned in the configuration.
