# Third-party notices

## Marked 17.0.5

- Purpose: build-time Markdown to HTML conversion
- File: vendor/marked.mjs
- License: MIT; full license in vendor/MARKED-LICENSE.md
- Source project: https://github.com/markedjs/marked
- The parser is bundled from the installed runtime package. No CDN request is required.

## Provided project files

Files in sources/ and the copied exercise archive retain their original provenance and any contained notices. No new redistribution license is asserted for KBS source code, business material, screenshots, or existing examples. The MCP example's dependencies are described in its own package.json and package-lock.json; they are not dependencies of the education portal.

## Fonts and network assets

The user-provided S-Core Dream font is copyright (c) 2018 S-Core Co., Ltd. All rights reserved. Original SCDream4.otf (Regular), SCDream5.otf (Medium), and SCDream6.otf (Bold) bytes are included in assets/fonts/. The original supplied license image is assets/fonts/S-Core-Dream-License.png; attribution is in assets/fonts/NOTICE.txt. No conversion, modification, subsetting, or individual font sale is performed. Other weights in the supplied ZIP are unused and are not included.

The current supplied reference is docs/design/DESIGN-together.ai.md; DESIGN-claude.md is retained only as a historical reference. The previous Chosun font is no longer distributed with this version. Design adaptation does not assert affiliation with either company. The earlier decorative ribbon and photographic scene have been replaced by a hybrid SVG that preserves the v1.4 image and animates botanical layers only. No external webfont, analytics service, remote image, or runtime CDN is required.

## KBS identity and collaboration image

The supplied KBS logo original is retained byte-for-byte in docs/brand/kbs-original.ai. Its horizontal first artboard was extracted as vector paths into assets/images/kbs-logo.svg, preserving geometry, proportions, and source colors. This is a use of the supplied KBS mark for the requested internal portal, not a new logo or a new redistribution license.

assets/images/team-collaboration-animated.svg embeds the exact original v1.4 PNG bytes once; it is a hybrid SVG, not a pure-vector conversion. The original is preserved in docs/design/base/team-v1.4-original.png and was generated with the built-in image tool in v1.4. The people, screens and architectural scene are not redrawn. The existing plant's foliage uses clipped copies of the original; two added plants use newly authored vector leaves and clipped original pot shapes. Only leaves animate. The user's plant crop is retained in docs/design/references/plant-reference.png. Editable construction code is scripts/build-hero.py. No external image service or script is required at runtime.
