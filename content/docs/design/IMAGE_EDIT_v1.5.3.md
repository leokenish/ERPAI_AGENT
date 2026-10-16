# v1.5.3 일러스트 편집 기록

방식: 기본 제공 imagegen 도구의 이미지 편집. 생성 PNG는 픽셀 후처리 없이 그대로 SVG에 내장했다.

기존 라이트 승인본을 기준으로 다크 의상·피부·윤곽·화면을 수정한 다음, 수정 다크를 기준으로 라이트 대응 이미지를 생성했다. 구도와 대상은 유지했지만 생성형 편집이므로 기존 픽셀과 완전히 동일한 도형이라고 표기하지 않는다. 양쪽 생성 PNG의 실제 크기는 1447×1087이며 표시 영역은 동일한 1448×1086이다.

## 다크 편집 프롬프트

```text
Use case: precise-object-edit.
Edit target: the supplied transparent isometric teamwork illustration. Make a clean DARK THEME companion for this exact existing illustration, not a new scene.
Preserve the source's 4:3 framing, all object positions, relative scale, silhouettes and poses: exactly FIVE existing people, central tall olive tree, FOUR smaller potted plants, all platforms, wired connections and monitors. Keep the rough minimal line illustration style, not realistic. Do not add or remove objects, crop, zoom, rearrange or put a background behind it. Keep a truly transparent background. Target canvas 1448 x 1086.
Repair and recolor these specific objects carefully:
1. ALL five people's ENTIRE trousers and both legs must be ivory white (#F4F3EF), including folds and the full length to each ankle. No black or gray half-leg patches. Clean continuous outlines and subtle gray fold lines.
2. Tops and sleeves should be medium/dark slate gray (#626D80), distinctly darker than skin; preserve a restrained periwinkle jacket accent on the two formerly cobalt-blue jackets. Clearly delineate every cuff/sleeve end from each wrist and hand with a crisp continuous seam. Hands cannot merge into sleeves.
3. All exposed faces, necks, hands, wrists and ankles light warm peach skin (#F2D5C2); all FIVE people's hair blonde (#DCC282).
4. All people's shoes in tasteful cognac brown (#936C4D), with darker brown soles and visible clean details.
5. All cobalt blue leaves, cables and accent objects to periwinkle blue #9AAEFF. Preserve plant structure and the dark central stems/midribs/veins in all four small potted plants, make them clearly visible as thin solid slate lines. Keep central olive tree leaves minimal.
6. Computer screen interior panels must fit their EXISTING frame boundaries perfectly in the same perspective, with even clean bezels. Make EVERY screen panel BLANK dark navy #26354D: remove old card/text/chart contents from 4 large/medium monitors, the small rightmost monitor and handheld tablet, for later vector animation overlay. Preserve the hand pointing in front of the foreground monitor. Laptop keyboards/outer casings remain as drawn.
7. Make ALL outlines smooth and continuous: no jagged pixelated dotted clothing outlines, no cut-off recolor rectangles, no patchwork seams or washed-out linework.
Platforms, pots and computer frames muted blue-gray #AFBED5 with clean darker contours. Preserve precise wiring routes and joints, illustration composition, object counts and entire canvas bounds. No text, labels, watermark, border, glow or background. Output a single polished transparent PNG asset, dark-theme colors.
```

## 라이트 편집 프롬프트

```text
Use case: precise-object-edit.
Image 1 is the EDIT TARGET: the repaired dark-theme transparent teamwork illustration. Image 2 is ONLY a light-theme COLOR reference. Create the light-theme companion of Image 1 while keeping its exact composition, canvas bounds, scale, silhouettes, positions, poses, clean cuff seams and monitor frame geometry. Do not redraw the layout or change any object size. Keep the same 4:3 1448 x 1086 transparent canvas.
Preserve the cleaned five people, olive tree, four small plants, monitors, wires and platforms of image 1.
Change ONLY the theme palette:
- Hair of all 5 people deep charcoal, trousers deep charcoal matching original light reference.
- Skin remains natural warm light peach on faces, necks, hands, wrists and ankles, so skin is clearly separate from sleeve cuffs. Every cuff seam and hand must remain visibly delineated with a solid continuous outline.
- Tops white/off-white except the left standing man's jacket and the bottom-right seated woman's top, which are cobalt #2454D6, matching Image 2.
- Shoes white with cobalt sole/trim (the same shoe silhouettes as Image 1).
- Periwinkle accents to cobalt blue. Platform surfaces, pots and computer frames white and light cool gray, matching Image 2. Keep crisp charcoal outlines and all small plants' central stems and midribs.
- Screen interiors BLANK ivory/white, perfectly aligned inside their existing bezel boundaries. No UI cards, charts, text or marks in ANY monitor or tablet; these will be animated as a vector overlay later. Keep foreground pointing hand in front of its screen.
Preserve exact geometry from Image 1, including all positions, crop, framing, people, plants, perspective and wired joints. Do not add/remove anything. No background, border, watermark, text, glow or shadows outside objects. Smooth continuous outlines, no dotted raster edge artifacts. Transparent PNG.
```

## 화면 애니메이션

프레임 안을 비운 이미지 위에 SVG 카드·글자·차트 23개를 그린다. 두 테마의 실제 빈 화면 영역을 교차하여 베젤과 앞쪽 손을 제외한 클립을 공유한다. PNG 위의 정보 그림을 지우는 방식이 아니므로 숨김 상태에 잔상이 남지 않는다. `scripts/build-hero.py`가 생성한다.
