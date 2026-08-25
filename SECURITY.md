<!--
SPDX-FileCopyrightText: 2026 Akihiko Komada <aki1770@gmail.com>
SPDX-License-Identifier: Apache-2.0
-->

# Security policy

## Who watches this package

`kuksa_dart_sdk` is listed on the [Eclipse KUKSA organisation page][org] under
**Third Party**, which that page defines as *"useful third party components that
are **not maintained or supported by the KUKSA team**."* The KUKSA project's
vulnerability-monitoring commitment covers repositories at Beta, Production,
Mature and Deprecated status; Third Party is not among them.

**So the KUKSA team does not monitor this package. We do.** This file exists so
that you have somewhere to write, which until now you did not.

[org]: https://github.com/eclipse-kuksa

## Reporting a vulnerability

Email **aki1770@gmail.com** with `kuksa_dart_sdk` in the subject. This address is
already published in every source file's SPDX header, so it is not a new one.

Please include the package version, what you observed, and how to reproduce it.
If you would rather not use email, open a
[GitHub security advisory](https://github.com/aki1770-del/kuksa_dart_sdk/security/advisories/new).

**What to expect.** An initial reply within **7 days**, and a resolution path
within **30 days**. Those are the same commitments this project stated publicly
on [eclipse-kuksa/kuksa-databroker#213](https://github.com/eclipse-kuksa/kuksa-databroker/issues/213)
on 2026-05-26, and we have not always met them: a pull request from a KUKSA
maintainer sat unread on this repository for 41 days. That is recorded here
rather than omitted, because a promise is worth what its history says it is.

## Supported versions

Only the latest published version receives fixes. There is no long-term-support
line.

| version | supported |
|---|---|
| 0.2.6 and later | yes |
| 0.2.4 – 0.2.5 | contract correct; upgrade for the subscription fix |
| 0.1.1 | backported unit fix for consumers pinned to `^0.1.0` |
| 0.1.0, 0.2.0 – 0.2.3 | **no — see below** |

## ⚠ A known defect in 0.1.0 and 0.2.0–0.2.3 that we cannot withdraw

Those versions documented `Vehicle.ADAS.ESC.RoadFriction.MostProbable` as a
float in `0.0–1.0` with the rule *"below 0.3 = icy"*. The real VSS unit is
**percent, 0–100**, and an ESC reporting black ice emits roughly **`18.0`** —
so `18.0 < 0.3` is false and ice is never detected. The same examples used
`friction ?? 1.0`, substituting full grip for an absent sensor.

**These versions cannot be retracted.** pub.dev allows retraction only within
seven days of publication, and every one of those windows had closed before the
defect was found. Their pages remain online and still show the wrong rule. If
you are on one of them, upgrade — and if you copied that comparison into your
own code, fix it there too, because upgrading this package will not.

## Scope

This SDK reads and classifies vehicle signals. It actuates nothing. A defect
here can cause a consuming application to display or infer something false about
a road — which is the class of defect the section above describes, and the reason
this file is not a formality.
