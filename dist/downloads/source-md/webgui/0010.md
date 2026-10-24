# ERP WebGUI·SYSTEMGUI — 100개 소스 색인

프로젝트: KBS ERP WebGUI·SYSTEMGUI 리팩토링 / 정리 기준일: 2026-10-08

출처: [기존 manifest](v3_evidence/manifest.json), [이번 Drive 목록](drive_inventory_2026-10-08.json), [기존 v3 보고서의 파일별 이유](ITS_Chrome_v3_Report.md).

모든 파일은 기존 ZIP에 완전한 바이트로 포함되어 있다. 아래 크기는 바이트 단위다. 이번에 모든 파일의 바이트·해시·버전 대응을 자동 확인했지만, 모든 함수를 다시 정밀 검토한 것은 아니다. 주요 변경의 상세 내용은 보고서와 diff에서 읽었고, 핵심 HTML/POST/메뉴/스크롤 연결은 해당 코드로 확인했다. 원격 Drive는 100개 메타데이터 대조이며 contextmenubase 외 99개 재다운로드는 하지 않았다.

`original`=제공 원본, `baseline`=v3 직전, `v3`=수정본. Drive 크기 일치는 내용 해시 일치가 아니다. 전체100개 중33개 변경(HTML14·JS16·CSS3),원본 대비 누적 변경은60개다. 운영 배포 상태는 미확인이다.

| 경로·파일명 | 형식 | 원본 | 직전 | v3 | 이번 변경 | 현재 Drive 원본 크기 대조 | 실제 확인 수준 / 교육 위치 |
|---|---|---:|---:|---:|---|---|---|
| `SYSTEMGUI/CSS/gui.css` | CSS | 3135 | 3248 | 3425 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/HTML/aboutbox.html` | HTML | 2238 | 2238 | 2238 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/HTML/contextmenubase.html` | HTML | 736 | 736 | 891 | 수정 | 일치 | 현재 Drive 본문+3버전 대조 / 02 사례3 |
| `SYSTEMGUI/HTML/dockingsash.html` | HTML | 1672 | 1672 | 1672 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/HTML/emptypage.html` | HTML | 263 | 263 | 263 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/HTML/endsess.html` | HTML | 2485 | 2485 | 2488 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/HTML/framepost.html` | HTML | 5249 | 5249 | 5382 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/HTML/hourglass.html` | HTML | 795 | 795 | 795 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/HTML/lodingpage.html` | HTML | 709 | 709 | 709 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/HTML/menubase.html` | HTML | 678 | 678 | 678 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/HTML/perfdisplay.html` | HTML | 617 | 617 | 617 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/HTML/sheerror.html` | HTML | 934 | 934 | 934 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/HTML/shmult.html` | HTML | 23053 | 23053 | 23038 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/HTML/splashscreen.html` | HTML | 2251 | 2251 | 2251 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/HTML/splittersash.html` | HTML | 1666 | 1666 | 1665 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/HTML/tabstripmenu.html` | HTML | 284 | 284 | 284 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/HTML/wgu_empty.html` | HTML | 263 | 263 | 263 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/HTML/wgu_pers_emptypage.html` | HTML | 513 | 513 | 626 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/HTML/wgu_pers_emptypage1.html` | HTML | 366 | 366 | 479 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/HTML/wgu_pers_emptypage2.html` | HTML | 505 | 505 | 622 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/JS/dss_list.js` | JS | 7767 | 7767 | 7767 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/JS/editorg.js` | JS | 4330 | 4330 | 4330 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/JS/its_domain.js` | JS | 1523 | 1523 | 1789 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/JS/its_frameset.js` | JS | 22777 | 22777 | 22779 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/JS/its_utils.js` | JS | 137591 | 138042 | 138841 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/JS/sap_commobj.js` | JS | 5654 | 5654 | 5900 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/JS/sap_externalwindowinterface.js` | JS | 3817 | 3817 | 3817 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/JS/sap_its.js` | JS | 8986 | 8986 | 8986 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/JS/sap_refreshinterface.js` | JS | 1646 | 1646 | 1646 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/JS/sap_savecancelinterface.js` | JS | 1208 | 1208 | 1208 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/JS/sap_secu.js` | JS | 26752 | 26752 | 27002 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/JS/sap_terminateinterface.js` | JS | 823 | 823 | 823 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `SYSTEMGUI/JS/sapwebframework.js` | JS | 46439 | 46439 | 46657 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/calendar.css` | CSS | 13247 | 13369 | 13369 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/columntree.css` | CSS | 13408 | 13546 | 13546 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/columntree_ie.css` | CSS | 1454 | 1454 | 1454 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/dynprolist.css` | CSS | 3930 | 4051 | 4051 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/edit.css` | CSS | 1220 | 1342 | 1342 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/generator.css` | CSS | 1235 | 1340 | 1340 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui.css` | CSS | 3231 | 3369 | 3546 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_bar.css` | CSS | 2424 | 2545 | 2545 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_button.css` | CSS | 4478 | 4622 | 4622 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_cua.css` | CSS | 8348 | 8474 | 8474 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_cua_ie.css` | CSS | 1352 | 1352 | 1352 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_dropdown.css` | CSS | 2170 | 2294 | 2541 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_dropdown_ie.css` | CSS | 62 | 62 | 62 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_dynpro_ie6.css` | CSS | 455 | 455 | 455 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_font.css` | CSS | 699 | 699 | 699 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_gridview.css` | CSS | 9877 | 10015 | 10015 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_gridview_ie.css` | CSS | 588 | 588 | 588 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_groupbox.css` | CSS | 1285 | 1414 | 1414 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_input.css` | CSS | 6256 | 6407 | 6407 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_page.css` | CSS | 2624 | 2753 | 2753 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_popup.css` | CSS | 3871 | 3988 | 3988 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_popupresize.css` | CSS | 1391 | 1494 | 1494 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_scroll.css` | CSS | 2195 | 2295 | 2295 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_splitter.css` | CSS | 2638 | 2760 | 2760 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_statusbar.css` | CSS | 2821 | 2936 | 2936 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_tablecontrol.css` | CSS | 7165 | 7319 | 7319 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_tablecontrol_ie.css` | CSS | 689 | 809 | 809 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_toolbar.css` | CSS | 595 | 704 | 704 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_toolbarctrl.css` | CSS | 4845 | 4985 | 4985 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_toolbarctrl_ie.css` | CSS | 65 | 65 | 65 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/gui_ts.css` | CSS | 4318 | 4437 | 4437 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/menu.css` | CSS | 3291 | 3415 | 3415 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/CSS/searchhelpctrl.css` | CSS | 13010 | 13134 | 13134 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/calendar.js` | JS | 51158 | 51298 | 51298 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/columntree.js` | JS | 163785 | 164345 | 164345 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/control.js` | JS | 32797 | 32797 | 32797 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/controldhtml.js` | JS | 7279 | 7279 | 7279 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/edit.js` | JS | 27621 | 27621 | 27621 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/ewtlib.js` | JS | 2979 | 2979 | 2979 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/gui.js` | JS | 39262 | 39530 | 39682 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/gui_a11y.js` | JS | 7731 | 7731 | 7731 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/gui_acf.js` | JS | 3683 | 3683 | 3683 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/gui_ctxtmenu.js` | JS | 1186 | 1186 | 1186 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/gui_cua.js` | JS | 15134 | 15134 | 15134 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/gui_dialogbox.js` | JS | 1668 | 1668 | 1668 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/gui_dropdown.js` | JS | 46453 | 46453 | 46892 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/gui_event.js` | JS | 54670 | 54766 | 54991 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/gui_form.js` | JS | 16042 | 16042 | 16042 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/gui_gridview.js` | JS | 131214 | 131571 | 131785 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/gui_list.js` | JS | 4651 | 4651 | 4651 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/gui_perf.js` | JS | 3586 | 3586 | 3586 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/gui_popupresize.js` | JS | 13919 | 13919 | 13919 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/gui_scroll.js` | JS | 65074 | 65846 | 66809 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/gui_shbutton.js` | JS | 6898 | 6898 | 6898 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/gui_splitter.js` | JS | 63712 | 63712 | 63712 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/gui_statusbar.js` | JS | 6080 | 6080 | 6080 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/gui_tablecontrol.js` | JS | 72129 | 72129 | 72343 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/gui_toolbarctrl.js` | JS | 36376 | 36376 | 36376 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/gui_ts.js` | JS | 3949 | 3949 | 3949 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/htmlviewer.js` | JS | 10617 | 10617 | 10617 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/itsdoc.js` | JS | 8472 | 8472 | 8472 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/menu.js` | JS | 44755 | 44755 | 45875 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/menubase.js` | JS | 10594 | 10594 | 10594 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/searchhelpctrl.js` | JS | 69081 | 69488 | 69488 | 유지 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/wgu_domain.js` | JS | 1523 | 1523 | 1789 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/wgu_frameset.js` | JS | 20266 | 20266 | 20268 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |
| `WEBGUI/JS/wgu_utils.js` | JS | 84774 | 84774 | 85223 | 수정 | 일치 | 바이트·해시 대조 / 01 §11·원문 보고서 |

