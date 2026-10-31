*&---------------------------------------------------------------------*
*&  Include           ZRPTH402TOP
*&---------------------------------------------------------------------*
REPORT zrpth411 MESSAGE-ID zhr.
TABLES: t510.

TYPE-POOLS: icon, slis, vrm.

INCLUDE <list>.
NODES: pernr.
INFOTYPES: 0001, 2010 MODE n.

DATA: gs_layout    TYPE lvc_s_layo,
      gs_print     TYPE lvc_s_prnt,
      gt_sorttab     TYPE lvc_t_sort WITH HEADER LINE,
      help_fieldcat  TYPE lvc_t_fcat WITH HEADER LINE.

DATA: g_control    TYPE scrfname VALUE 'CONTROL',
      g_container  TYPE REF TO cl_gui_custom_container,
      g_grid       TYPE REF TO cl_gui_alv_grid,
      ok_code      LIKE sy-ucomm,
      g_repid      LIKE sy-repid,
      save_ok      LIKE sy-ucomm.




DATA: g_selected LIKE help_info-fieldname,
      g_tabix LIKE sy-tabix,
      g_selected_value LIKE help_info-fldvalue.


DATA: cancel_flag(01) TYPE c,
      exit_flag(01) TYPE c,
      g_title(100).

DATA: icon_red TYPE char4, icon_green TYPE char4, icon_yellow TYPE char4.


DATA: editor_container TYPE REF TO cl_gui_custom_container,
      editor           TYPE REF TO cl_gui_textedit.

DATA: gt_list_top_of_page  TYPE slis_t_listheader,
      gt_events TYPE slis_t_event,
      gs_event  TYPE slis_alv_event,
      gs_variant TYPE disvariant.

DATA: o_dyndoc_id TYPE REF TO cl_dd_document,
      o_html_cntl TYPE  REF TO cl_gui_html_viewer,
      o_parent_top TYPE REF TO cl_gui_container,
      o_splitter TYPE REF TO cl_gui_splitter_container,
      o_parent_grid TYPE REF TO cl_gui_container.

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION .
  PUBLIC SECTION.
    METHODS: handle_top_of_page FOR EVENT top_of_page OF cl_gui_alv_grid
                                                  IMPORTING e_dyndoc_id.

ENDCLASS.                    "lcl_event_handler DEFINITION


*---------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD handle_top_of_page.
    PERFORM event_top_of_page USING o_dyndoc_id.
  ENDMETHOD.                    "handle_top_of_page
ENDCLASS.                    "lcl_event_handler IMPLEMENTATION
DATA: g_handler TYPE REF TO  lcl_event_handler.

*---------------------------------------------------------------------*
DATA: BEGIN OF gt_disp OCCURS 0,
              mark,
              ename TYPE emnam,
              zpname  TYPE emnam,
              zztrfgr      TYPE pa0001-zztrfgr, " 직급
              orgeh_tx TYPE zth0500-fname,
              vdsk1 TYPE pa0001-vdsk1,
              vdsk1_tx TYPE zth0500-fname,
              kostl TYPE pa0001-kostl,
              kokrs TYPE pa0001-kokrs,
              kostl_tx TYPE hrca_costc-name,
              plans TYPE pa0001-plans,
              plans_tx TYPE objec-stext,
              persk TYPE pa0001-persk,
              persk_tx TYPE t503t-ptext,
              jikjong_k TYPE pa0001-jikjong_k,
              z52wktp_tx TYPE char40,
              message(40).
        INCLUDE STRUCTURE   zthr0112.
DATA:   END  OF gt_disp.


DATA: BEGIN OF gt_disp2 OCCURS 0,
              state(8),
              ename TYPE emnam,
              orgeh_tx TYPE zth0500-fname,
              vdsk1 TYPE pa0001-vdsk1,
              vdsk1_tx TYPE zth0500-fname,
              kostl TYPE pa0001-kostl,
              kokrs TYPE pa0001-kokrs,
              kostl_tx TYPE hrca_costc-name,
              plans TYPE pa0001-plans,
              plans_tx TYPE objec-stext,
              persk TYPE pa0001-persk,
              persk_tx TYPE t503t-ptext,
              jikjong_k TYPE pa0001-jikjong_k,
              z52wktxt TYPE ze52wktxt,
              awref TYPE awref,
              zgl01 TYPE zthrbs01-zgl01. " g/l 계정 추가 xa30752 2020.02.
        INCLUDE STRUCTURE   zthr0113.
DATA:   END  OF gt_disp2.

* 화면 전용. 확정 저장에는 사용하지 않는다.
DATA: BEGIN OF gt_display OCCURS 0.
        INCLUDE STRUCTURE gt_disp2.
DATA:   row_kind(1),
        row_text(20),
        target_ym TYPE zthr0113-zadmit_ym,
        old_amt TYPE zthr0113-zrlprdamt,
        diff_amt TYPE zthr0113-zrlprdamt,
        row_order TYPE i,
      END OF gt_display.

DATA: gt_retro_new TYPE STANDARD TABLE OF zthr0113
                  WITH HEADER LINE,
      gt_retro_old TYPE STANDARD TABLE OF zthr0113
                  WITH HEADER LINE.

DATA: BEGIN OF gt_cost_applied OCCURS 0,
        zadmit_ym TYPE zthr0113-zadmit_ym,
        pernr TYPE zthr0113-pernr,
      END OF gt_cost_applied.


DATA: BEGIN OF gt_disp3 OCCURS 0,
              state(8),
              zadmit_ym TYPE zezadmit_ym,
              zadmit_dt TYPE zeadmit_dt,
              pernr TYPE persno,
              ename TYPE emnam,
              orgeh_tx TYPE zth0500-fname,
              vdsk1 TYPE pa0001-vdsk1,
              vdsk1_tx TYPE zth0500-fname,
              kostl TYPE pa0001-kostl,
              kokrs TYPE pa0001-kokrs,
              kostl_tx TYPE hrca_costc-name,
              plans TYPE pa0001-plans,
              plans_tx TYPE objec-stext,
              persk TYPE pa0001-persk,
              persk_tx TYPE t503t-ptext,
              jikjong_k TYPE pa0001-jikjong_k,
              z52wktxt TYPE ze52wktxt,
              zotpayamt	TYPE zeotpayamt,
              lgart TYPE lgart,
              lgtxt TYPE lgtxt,
              betrg TYPE betrg,
              awref TYPE awref.
DATA:   END  OF gt_disp3.


DATA: gt_0112 TYPE TABLE OF zthr0112 WITH HEADER LINE,
      gt_0113 TYPE TABLE OF zthr0113 WITH HEADER LINE,
      gt_0500 TYPE STANDARD TABLE OF zth0500 WITH HEADER LINE.

DATA: g_mon_eda TYPE datum.
DATA: g_wktp_tx TYPE ddtext.
DATA: gv_pcnt TYPE string.

DATA: gt_dynpfields TYPE TABLE OF dynpread WITH HEADER LINE,
      gt_return LIKE ddshretval OCCURS 0 WITH HEADER LINE,
      gt_dselc LIKE dselc OCCURS 0 WITH HEADER LINE.

DATA: BEGIN OF gt_data_down OCCURS 0,
      state(20),
      pernr(20),
      ename(20),
      orgeh_tx(30),
      vdsk1(20),
      vdsk1_tx(20),
      kostl(20),
      kostl_tx(20),
      persk_tx(20),
      plans_tx(20),
      jikjong_k(20),
      zztrfgr(20),
      zdung(20),
      zcost(20),
      z52wktxt(20),
      z52prsq(20),
      begda(20),
      endda(20),
      pwkhr(20),
      zwkhrtot(20),
      zhkhrtot(20),
      zrlwkhrtot(20),
      zrlwkhr(20),
      zpubhhr(20),
      zprsdwkhr(20),
      zadtwkhr(20),
      zedtwkhr(20),
      zrladdwkhr(20),
      zrlexwkhr(20),
      zdaeh_day(20),
      zdaehhr(20),
      zdaehamt(20),
      zrlovrwkhr(20),
      zrlovramt(20),
      zrlngtwkhr(20),
      zrlngtamt(20),
      zrlholwkhr(20),
      zrlholamt(20),
      tdcost(20),
      zrlprdamt(20),
      zretroamt(20),
      zotpayamt(20),
      zgl01(20),
      row_text(20),
      target_ym(20),
      old_amt(20),
      diff_amt(20),
      END OF gt_data_down.

DATA: BEGIN OF gt_data_down2 OCCURS 0,
      state_txt(20),
      pernr(20),
      ename(20),
      orgeh_tx(30),
      vdsk1(20),
      vdsk1_tx(20),
      kostl(20),
      kostl_tx(20),
      persk_tx(20),
      plans_tx(20),
      jikjong_k(20),
      datum(20),
      zbegtm(20),
      zendtm(20),
      zrlwk_tm(20),
      zdaeh(20),
      zpernr(20),
      zpname(20),
      reqdt(20),
      zcosa(20),
      zcope(20),
      END OF gt_data_down2.

DATA: BEGIN OF gt_data_down3 OCCURS 0,
      state(20),
      zadmit_ym(20),
      zadmit_dt(20),
      pernr(20),
      ename(20),
      orgeh_tx(30),
      vdsk1(20),
      vdsk1_tx(20),
      kostl(20),
      kostl_tx(20),
      persk_tx(20),
      plans_tx(20),
      jikjong_k(20),
      z52wktxt(20),
      zotpayamt(20),
      lgart(20),
      lgtxt(20),
      betrg(20),
      awref(20),
      END OF gt_data_down3.

DATA: BEGIN OF gt_title OCCURS 0,
       text(50),
     END OF gt_title.

*---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME TITLE text-001.

* 정산연월

PARAMETERS       : pa_yymm LIKE sy-datum(6) OBLIGATORY DEFAULT sy-datum(6) .
* 탄력근로제유형
PARAMETERS       : pa_zwktp TYPE ze52wktp DEFAULT '0110' OBLIGATORY.
* 근로주기
PARAMETERS       : pa_zseq TYPE ze52prsq DEFAULT '04' OBLIGATORY.


*
SELECTION-SCREEN : BEGIN OF LINE.
SELECTION-SCREEN : COMMENT 1(10) text-002 FOR  FIELD rb1.
PARAMETER  : rb1 RADIOBUTTON GROUP a1.
SELECTION-SCREEN : COMMENT 30(10) text-003 FOR  FIELD rb2.
PARAMETER  : rb2 RADIOBUTTON GROUP a1.
SELECTION-SCREEN : COMMENT 50(10) text-004 FOR  FIELD rb3.
PARAMETER  : rb3 RADIOBUTTON GROUP a1.
SELECTION-SCREEN : COMMENT 70(15) text-005 FOR  FIELD rb4.
PARAMETER  : rb4 RADIOBUTTON GROUP a1.
SELECTION-SCREEN : END OF LINE.

PARAMETER: pa_admdt LIKE sy-datum.


SELECTION-SCREEN END   OF BLOCK blk1.

SELECTION-SCREEN BEGIN OF BLOCK blk2 WITH FRAME TITLE text-001.
PARAMETER: pa_retro AS CHECKBOX.
PARAMETER: pa_retmo TYPE zyearmon.
SELECTION-SCREEN END   OF BLOCK blk2.
