Background
==========
Tests for the same situation as `thread*msg*block*w*queue`, but without an initialized message queue for the main thread:

This test application checks for the behavior reported in https://github.com/RIOT-OS/RIOT/issues/100:

Usually, when a thread (here `sender*thread`) sends a message to another thread (here the `main` thread) whose message queue already holds a message, the message of `sender*thread` is copied into `main`'s message queue and `sender*thread` is set to `STATUS*PENDING`. However, this should *not* happen if `sender*thread` is currently in `STATUS*REPLY_BLOCKED` mode, since it is in the middle of a different, blocking send.

In the aforementioned issue, it was reported that this undesired behavior was happening. It has been fixed since, and this test ensures that it doesn't re-occur again.

Expected result
===============
The output should look as follows:

```
sender_thread start
main thread alive
```

If you see
```
ERROR: sender_thread should be blocking
```
something went wrong.