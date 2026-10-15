REPORT z_package_export LINE-SIZE 180.
*---------------------------------------------------------------------*
* DEVHUB Export 0.3.18 - partial exporter, SAP validation pending.
* Target: SAP_BASIS 700 SP0041 Unicode / Windows SAP GUI.
* Interfaces evidenced in user's result.txt, 2026-09-18, KSD/300.
* No Repository writes, no business-table rows, no CTS changes.
* PROG: active body, KO-first text pools, attributes, direct INCLUDEs.
* DDIC: TABL/DTEL/DOMA/VIEW/TTYP/SHLP active API definitions.
* FUGR: directory-verified functions; API source/interface version U.
* Owned FUGR includes: verified API/TADIR owner, bounded lexical walk.
* Direct INCLUDE reader is lexical and partial, not a syntax checker.
* WAPA: active BSP pages/events/parameters; SMIM/W3MI: raw MIME bytes.
* MSAG: KO-first T100 messages, EN for missing numbers; no long text.
* SMIM under an unselected BSP package: reference only, no content read.
* CLAS stays unsupported; class-reference diagnostics are omitted.
* Known MIME URL/DDIC serialization omissions: SKIPPED + WARNING.
* Other errors retain FAILED; no repository data is repaired or changed.
* Every file is ANALYSIS_ONLY. Import support is NOT implemented here.
* Compile and validate on SAP before relying on the output.
*---------------------------------------------------------------------*
TABLES: tdevc, tadir.
DATA gv_language_selection TYPE c LENGTH 2.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(28) c_pack FOR FIELD s_pack.
SELECTION-SCREEN POSITION 33.
SELECT-OPTIONS s_pack FOR tdevc-devclass OBLIGATORY.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(28) c_file FOR FIELD p_file.
SELECTION-SCREEN POSITION 33.
PARAMETERS p_file TYPE c LENGTH 255 LOWER CASE VISIBLE LENGTH 45.
SELECTION-SCREEN END OF LINE.
* Fixed output policy; this range is metadata, not a selection field.
RANGES s_lang FOR gv_language_selection.
PARAMETERS: p_sub TYPE c LENGTH 1 DEFAULT 'X' NO-DISPLAY,
            p_mb TYPE i DEFAULT 512 NO-DISPLAY.

TYPES: ty_name TYPE c LENGTH 40,
       ty_names TYPE STANDARD TABLE OF ty_name,
       ty_lines TYPE STANDARD TABLE OF string,
       ty_binary_line TYPE x LENGTH 255,
       ty_binary TYPE STANDARD TABLE OF ty_binary_line.
TYPES ty_messages TYPE STANDARD TABLE OF t100.
TYPES: BEGIN OF ty_package,
         devclass TYPE tdevc-devclass,
       END OF ty_package.
TYPES ty_packages TYPE STANDARD TABLE OF ty_package.
TYPES: BEGIN OF ty_object,
         pgmid TYPE tadir-pgmid,
         object TYPE tadir-object,
         obj_name TYPE tadir-obj_name,
         devclass TYPE tadir-devclass,
         status TYPE c LENGTH 20,
         reason TYPE string,
       END OF ty_object.
TYPES: BEGIN OF ty_file,
         path TYPE string,
         baseline TYPE string,
         devclass TYPE tadir-devclass,
         object TYPE tadir-object,
         obj_name TYPE tadir-obj_name,
         component TYPE string,
         language TYPE sy-langu,
         active_state TYPE c LENGTH 1,
         byte_length TYPE i,
         checksum_algorithm TYPE c LENGTH 20,
         checksum TYPE i,
         capability TYPE c LENGTH 20,
         check_mode TYPE c LENGTH 12,
       END OF ty_file.
TYPES: BEGIN OF ty_ref,
         source_program TYPE ty_name,
         target_program TYPE ty_name,
         target_package TYPE tadir-devclass,
         relation TYPE c LENGTH 24,
         scope TYPE c LENGTH 24,
         source_line TYPE i,
         optional TYPE c LENGTH 1,
         evidence TYPE c LENGTH 24,
         owner_object TYPE tadir-object,
         owner_name TYPE tadir-obj_name,
         owner_evidence TYPE c LENGTH 24,
         owner_detail TYPE string,
       END OF ty_ref.
TYPES: BEGIN OF ty_owner,
         program TYPE ty_name,
         object TYPE tadir-object,
         obj_name TYPE tadir-obj_name,
         devclass TYPE tadir-devclass,
         main_program TYPE ty_name,
         verified TYPE c LENGTH 1,
         evidence TYPE c LENGTH 24,
         detail TYPE string,
       END OF ty_owner.
TYPES: BEGIN OF ty_owned_include,
         program TYPE ty_name,
         source_program TYPE ty_name,
         owner_object TYPE tadir-object,
         owner_name TYPE tadir-obj_name,
         owner_package TYPE tadir-devclass,
         owner_evidence TYPE c LENGTH 24,
         status TYPE c LENGTH 20,
         detail TYPE string,
       END OF ty_owned_include.
TYPES: BEGIN OF ty_include,
         name TYPE ty_name,
         source_line TYPE i,
         optional TYPE c LENGTH 1,
         evidence TYPE c LENGTH 24,
       END OF ty_include,
       ty_includes TYPE STANDARD TABLE OF ty_include.
TYPES: BEGIN OF ty_scan_gap,
         source_line TYPE i,
         reason TYPE c LENGTH 50,
         target_token TYPE string,
       END OF ty_scan_gap,
       ty_scan_gaps TYPE STANDARD TABLE OF ty_scan_gap.
TYPES: BEGIN OF ty_function,
         funcname TYPE rs38l-name,
         area TYPE rs38l-area,
         main_program TYPE ty_name,
       END OF ty_function,
       ty_functions TYPE STANDARD TABLE OF ty_function.
TYPES: BEGIN OF ty_log,
         object TYPE tadir-object,
         obj_name TYPE tadir-obj_name,
         stage TYPE c LENGTH 30,
         component TYPE ty_name,
         status TYPE c LENGTH 20,
         detail TYPE string,
       END OF ty_log.
TYPES: BEGIN OF ty_header,
         format TYPE c LENGTH 30,
         version TYPE c LENGTH 10,
         tool_version TYPE c LENGTH 10,
         sysid TYPE sy-sysid,
         client TYPE sy-mandt,
         basis TYPE sy-saprl,
         unicode TYPE c LENGTH 1,
         support_package_evidence TYPE c LENGTH 60,
         dependency_policy TYPE c LENGTH 24,
         completeness TYPE c LENGTH 20,
         dependency_coverage TYPE c LENGTH 40,
         import_enabled TYPE c LENGTH 1,
         checksum_security TYPE c LENGTH 60,
         normalization TYPE c LENGTH 60,
         language_at_initialization TYPE sy-langu,
         language_at_start TYPE sy-langu,
         korean_language_key TYPE sy-langu,
         english_language_key TYPE sy-langu,
         language_policy TYPE c LENGTH 30,
         language_selection_format TYPE c LENGTH 16,
       END OF ty_header.

TYPES: BEGIN OF ty_web_asset,
         object TYPE tadir-object,
         obj_name TYPE tadir-obj_name,
         devclass TYPE tadir-devclass,
         kind TYPE c LENGTH 24,
         component TYPE string,
         original_path TYPE string,
         requested_language TYPE sy-langu,
         language TYPE sy-langu,
         content_path TYPE string,
         metadata_path TYPE string,
         mime_type TYPE string,
         byte_length TYPE i,
         active_state TYPE c LENGTH 1,
         status TYPE c LENGTH 20,
         detail TYPE string,
       END OF ty_web_asset.
TYPES: BEGIN OF ty_mime_metadata,
         object TYPE tadir-object,
         obj_name TYPE tadir-obj_name,
         devclass TYPE tadir-devclass,
         loio TYPE sdok_docid,
         phio TYPE sdok_phid,
         url TYPE string,
         is_folder TYPE boole_d,
         mime_type TYPE string,
         requested_language TYPE sy-langu,
         actual_language TYPE sy-langu,
         byte_length TYPE i,
         content_path TYPE string,
         active_state TYPE c LENGTH 1,
         status TYPE c LENGTH 20,
         detail TYPE string,
       END OF ty_mime_metadata.
TYPES: BEGIN OF ty_web_ref,
         object TYPE tadir-object,
         obj_name TYPE tadir-obj_name,
         component TYPE string,
         target_object TYPE tadir-object,
         target_name TYPE string,
         target_package TYPE tadir-devclass,
         scope TYPE c LENGTH 24,
         evidence TYPE c LENGTH 40,
       END OF ty_web_ref.
TYPES: BEGIN OF ty_bsp_path,
         pagekey TYPE o2pagkey-pagekey,
         original_name TYPE string,
         read_language TYPE sy-langu,
         read_iso TYPE c LENGTH 2,
         stem TYPE string,
         folder TYPE string,
         disambiguated TYPE c LENGTH 1,
         error TYPE string,
       END OF ty_bsp_path,
       ty_bsp_paths TYPE STANDARD TABLE OF ty_bsp_path,
       ty_bsp_keys TYPE SORTED TABLE OF o2pagkey
         WITH UNIQUE KEY applname pagekey.
DATA: gt_mime_metadata TYPE STANDARD TABLE OF ty_mime_metadata,
      gt_web_assets TYPE STANDARD TABLE OF ty_web_asset,
      gt_web_refs TYPE STANDARD TABLE OF ty_web_ref,
      gv_check_mode TYPE c LENGTH 12.

DATA: gt_packages TYPE STANDARD TABLE OF ty_package,
      gt_seen_pkg TYPE SORTED TABLE OF ty_package
        WITH UNIQUE KEY devclass,
      gt_objects TYPE STANDARD TABLE OF ty_object,
      gt_files TYPE STANDARD TABLE OF ty_file,
      gt_refs TYPE STANDARD TABLE OF ty_ref,
      gt_logs TYPE STANDARD TABLE OF ty_log,
      gt_paths TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line,
      gt_done_smim TYPE SORTED TABLE OF ty_name
        WITH UNIQUE KEY table_line,
      gt_scanned TYPE SORTED TABLE OF ty_name
        WITH UNIQUE KEY table_line,
      gt_owners TYPE SORTED TABLE OF ty_owner WITH UNIQUE KEY program,
      gt_include_queue TYPE STANDARD TABLE OF ty_owned_include,
      gt_queued TYPE SORTED TABLE OF ty_name WITH UNIQUE KEY table_line,
      gt_fugr_mains TYPE SORTED TABLE OF ty_name
        WITH UNIQUE KEY table_line,
      gt_owner_api_meta TYPE STANDARD TABLE OF fupararef,
      gv_owner_prepared TYPE c LENGTH 1,
      gv_owner_ready TYPE c LENGTH 1,
      gv_owner_reason TYPE string,
      gs_package TYPE ty_package,
      gs_object TYPE ty_object,
      gs_header TYPE ty_header,
      go_zip TYPE REF TO cl_abap_zip,
      gv_root TYPE string,
      gv_archive_name TYPE string,
      gv_fatal TYPE string,
      gv_bytes TYPE i,
      gv_maxbytes TYPE i,
      gv_lf TYPE string,
      gv_tab TYPE string,
      gv_language_init TYPE sy-langu,
      gv_language_start TYPE sy-langu,
      gv_language_ko TYPE sy-langu,
      gv_language_en TYPE sy-langu,
      gv_fm_prepared TYPE c LENGTH 1,
      gv_function_api TYPE c LENGTH 30,
      gv_api_reason TYPE string,
      gt_new_api_meta TYPE STANDARD TABLE OF fupararef,
      gr_new_source TYPE REF TO data,
      gv_component TYPE ty_name,
      gv_payload_state TYPE c LENGTH 1,
      gv_file_language TYPE sy-langu,
      gv_stage TYPE c LENGTH 30,
      gv_count TYPE i,
      gv_index TYPE i,
      gv_zip TYPE xstring,
      gv_error TYPE string,
      gv_ok TYPE c LENGTH 1,
      go_error TYPE REF TO cx_root.

INITIALIZATION.
  c_pack = '개발클래스(패키지)'.
  c_file = '저장경로'.
  gv_language_init = sy-langu.
  s_lang-sign = 'I'.
  s_lang-option = 'EQ'.
  s_lang-low = 'KO'.
  APPEND s_lang.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM choose_file.

AT SELECTION-SCREEN.
* Hidden run policy is fixed even when an old variant is loaded.
  p_sub = 'X'.
  p_mb = 512.
  LOOP AT s_pack.
    IF s_pack-sign <> 'I' OR
       ( s_pack-option <> 'EQ' AND s_pack-option <> 'BT' AND
         s_pack-option <> 'CP' ).
      MESSAGE 'Packages: use positive EQ, BT or CP selections'
        TYPE 'E'.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.
  p_sub = 'X'.
  p_mb = 512.
  CLEAR gv_archive_name.
  gv_language_start = sy-langu.
  IF sy-batch = 'X'.
    WRITE: / 'STOP: run interactively in Windows SAP GUI.'.
    RETURN.
  ENDIF.
  gv_maxbytes = p_mb * 1024 * 1024.
  TRY.
      PERFORM preflight.
      IF gv_fatal IS NOT INITIAL.
        WRITE: / 'STOP:', gv_fatal.
        RETURN.
      ENDIF.
      PERFORM create_zip CHANGING go_zip.
      PERFORM discover.
      IF gv_fatal IS NOT INITIAL.
        WRITE: / 'STOP:', gv_fatal.
        RETURN.
      ENDIF.
* Discover roots before choosing the final package-based ZIP filename.
      IF p_file IS INITIAL. PERFORM choose_file. ENDIF.
      IF p_file IS INITIAL.
        WRITE: / 'Cancelled: no destination selected.'. RETURN.
      ENDIF.
      PERFORM prepare_destination.
      IF gv_fatal IS NOT INITIAL.
        WRITE: / 'STOP:', gv_fatal. RETURN.
      ENDIF.
      LOOP AT gt_objects INTO gs_object.
        gv_index = sy-tabix.
        CLEAR: gv_file_language, gv_root, gv_stage, gv_component,
               gv_payload_state, gv_check_mode.
        IF gs_object-pgmid <> 'R3TR'.
          gs_object-status = 'UNSUPPORTED'.
          gs_object-reason = 'Non-R3TR entry: catalog only'.
        ELSE.
          TRY.
              PERFORM export_object.
            CATCH cx_root INTO go_error.
              PERFORM object_error USING go_error.
          ENDTRY.
        ENDIF.
        MODIFY gt_objects FROM gs_object INDEX gv_index.
        IF gv_fatal IS NOT INITIAL.
          EXIT.
        ENDIF.
      ENDLOOP.
      IF gv_fatal IS NOT INITIAL.
        WRITE: / 'STOP, ZIP not downloaded:', gv_fatal.
        RETURN.
      ENDIF.
      PERFORM finalize.
      IF gv_fatal IS NOT INITIAL.
        WRITE: / 'STOP, ZIP not downloaded:', gv_fatal.
        RETURN.
      ENDIF.
      CALL METHOD go_zip->save RECEIVING zip = gv_zip.
      PERFORM download.
    CATCH cx_root INTO go_error.
      gv_error = go_error->get_text( ).
      WRITE: / 'STOP:', gv_stage, gv_error.
      RETURN.
  ENDTRY.

FORM choose_file.
  DATA: lv_name TYPE string,
        lv_dir TYPE string,
        lv_full TYPE string,
        lv_action TYPE i,
        lv_default TYPE string,
        lt_roots TYPE ty_packages,
        ls_root TYPE ty_package.
  lv_default = gv_archive_name.
  IF lv_default IS INITIAL.
* F4 may precede selection-screen transport. The actual filename is
* always recomputed from resolved roots before download.
    LOOP AT s_pack WHERE sign = 'I' AND option = 'EQ'.
      ls_root-devclass = s_pack-low. APPEND ls_root TO lt_roots.
    ENDLOOP.
    PERFORM archive_filename USING lt_roots CHANGING lv_default.
  ENDIF.
  TRY.
      CALL METHOD cl_gui_frontend_services=>file_save_dialog
        EXPORTING
          window_title = 'DEVHUB - save a new export ZIP'
          default_extension = 'zip'
          default_file_name = lv_default
          file_filter = 'ZIP (*.zip)|*.zip|'
          prompt_on_overwrite = 'X'
        CHANGING
          filename = lv_name path = lv_dir fullpath = lv_full
          user_action = lv_action
        EXCEPTIONS OTHERS = 1.
      IF sy-subrc = 0 AND lv_full IS NOT INITIAL.
        IF strlen( lv_full ) <= 255.
          p_file = lv_full.
        ELSE.
          MESSAGE 'Destination exceeds 255 characters' TYPE 'I'.
        ENDIF.
      ENDIF.
    CATCH cx_root.
      MESSAGE 'File dialog failed; enter a folder or a full ZIP path'
        TYPE 'I'.
  ENDTRY.
ENDFORM.

FORM archive_filename USING pt_roots TYPE ty_packages
                      CHANGING cv_name TYPE string.
  DATA: lt_roots TYPE ty_packages, ls_root TYPE ty_package,
        lv_count TYPE i, lv_more TYPE c LENGTH 12, lv_name TYPE string.
  lt_roots = pt_roots.
  SORT lt_roots BY devclass.
  DELETE ADJACENT DUPLICATES FROM lt_roots COMPARING devclass.
  DESCRIBE TABLE lt_roots LINES lv_count.
  cv_name = 'packages_export.zip'.
  IF lv_count = 0. RETURN. ENDIF.
  READ TABLE lt_roots INTO ls_root INDEX 1.
  PERFORM segment USING ls_root-devclass CHANGING lv_name.
  IF lv_count = 1.
    CONCATENATE lv_name '_export.zip' INTO cv_name.
  ELSE.
    SUBTRACT 1 FROM lv_count.
    WRITE lv_count TO lv_more. CONDENSE lv_more.
    CONCATENATE lv_name '_plus_' lv_more '_export.zip' INTO cv_name.
  ENDIF.
ENDFORM.

FORM destination_path USING pv_input TYPE csequence
                            pv_name TYPE string
                      CHANGING cv_path TYPE string cv_error TYPE string.
  DATA: lv_input TYPE string, lv_upper TYPE string,
        lv_len TYPE i, lv_offset TYPE i, lv_last TYPE i,
        lv_char TYPE c LENGTH 1.
  CLEAR: cv_path, cv_error.
  lv_input = pv_input.
  lv_len = strlen( lv_input ).
  IF lv_len = 0 OR pv_name IS INITIAL.
    cv_error = 'Destination or package ZIP filename is empty'. RETURN.
  ENDIF.
  lv_upper = lv_input. TRANSLATE lv_upper TO UPPER CASE.
  lv_last = -1.
  IF lv_len >= 4.
    lv_offset = lv_len - 4.
    IF lv_upper+lv_offset(4) = '.ZIP'.
* Keep the chosen directory, replace any previously chosen ZIP basename.
      DO lv_len TIMES.
        lv_offset = sy-index - 1.
        lv_char = lv_input+lv_offset(1).
        IF lv_char = '/' OR lv_char = '\'. lv_last = lv_offset. ENDIF.
      ENDDO.
      IF lv_last >= 0.
        lv_offset = lv_last + 1.
        lv_input = lv_input(lv_offset).
      ELSE.
        CLEAR lv_input.
      ENDIF.
    ENDIF.
  ENDIF.
  lv_len = strlen( lv_input ).
  IF lv_len > 0.
    lv_offset = lv_len - 1.
    lv_char = lv_input+lv_offset(1).
    IF lv_char <> '/' AND lv_char <> '\'.
      CONCATENATE lv_input '\' INTO lv_input.
    ENDIF.
  ENDIF.
  CONCATENATE lv_input pv_name INTO cv_path.
  IF strlen( cv_path ) > 255.
    CLEAR cv_path. cv_error = 'Destination exceeds 255 characters'.
  ENDIF.
ENDFORM.

FORM prepare_destination.
  DATA lv_path TYPE string.
  PERFORM destination_path USING p_file gv_archive_name
    CHANGING lv_path gv_fatal.
  IF gv_fatal IS INITIAL. p_file = lv_path. ENDIF.
ENDFORM.

FORM preflight.
  DATA: lo_in TYPE REF TO cl_abap_conv_in_ce,
        lo_test TYPE REF TO cl_abap_zip,
        lv_expected TYPE xstring,
        lv_actual TYPE xstring,
        lv_test TYPE string,
        lv_char TYPE c LENGTH 1,
        lv_char_bytes TYPE i,
        lv_lfbytes TYPE xstring,
        lv_crcbytes TYPE xstring,
        lv_crc TYPE i.
  gv_stage = 'PREFLIGHT'.
  PERFORM resolve_languages.
  IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  IF sy-saprl <> '700'.
    gv_fatal = 'This validation build targets SAP_BASIS 700 only'.
    RETURN.
  ENDIF.
  DESCRIBE FIELD lv_char LENGTH lv_char_bytes IN BYTE MODE.
  IF lv_char_bytes <> 2.
    gv_fatal = 'This validation build requires the verified Unicode mode'.
    RETURN.
  ENDIF.
* UTF-8 bytes of Korean text followed by LF, without source-codepage
* dependency. This checks the converter on the actual SAP runtime.
  lv_expected = 'ED959CEAB8800A'.
  CALL METHOD cl_abap_conv_in_ce=>create
    EXPORTING encoding = 'UTF-8' input = lv_expected ignore_cerr = ' '
    RECEIVING conv = lo_in.
  CALL METHOD lo_in->read IMPORTING data = lv_test.
  PERFORM utf8 USING lv_test CHANGING lv_actual.
  IF lv_actual <> lv_expected.
    gv_fatal = 'UTF-8 round-trip failed'.
    RETURN.
  ENDIF.
  lv_lfbytes = '0A'.
  CALL METHOD cl_abap_conv_in_ce=>create
    EXPORTING encoding = 'UTF-8' input = lv_lfbytes ignore_cerr = ' '
    RECEIVING conv = lo_in.
  CALL METHOD lo_in->read IMPORTING data = gv_lf.
  lv_lfbytes = '09'.
  CALL METHOD cl_abap_conv_in_ce=>create
    EXPORTING encoding = 'UTF-8' input = lv_lfbytes ignore_cerr = ' '
    RECEIVING conv = lo_in.
  CALL METHOD lo_in->read IMPORTING data = gv_tab.
  PERFORM test_include_reader.
  IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  PERFORM test_include_scope.
  IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  PERFORM test_function_source_choice.
  IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  PERFORM test_web_helpers.
  IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  PERFORM test_bsp_metadata_xml USING lv_test.
  IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  PERFORM test_pretty_xml USING lv_test.
  IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  PERFORM test_message_xml USING lv_test.
  IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  PERFORM create_zip CHANGING lo_test.
  CALL METHOD lo_test->add
    EXPORTING name = 'selftest.txt' content = lv_actual.
  CLEAR lv_actual.
  CALL METHOD lo_test->get
    EXPORTING name = 'selftest.txt'
    IMPORTING content = lv_actual
    EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0 OR lv_actual <> lv_expected.
    gv_fatal = 'ZIP ADD/GET self-test failed'.
    RETURN.
  ENDIF.
  PERFORM test_zip_names USING lo_test.
  IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  lv_crcbytes = '313233343536373839'.
  CALL METHOD cl_abap_zip=>crc32
    EXPORTING content = lv_crcbytes RECEIVING crc32 = lv_crc.
  IF lv_crc <> -873187034.
    gv_fatal = 'CRC32 known-vector self-test failed'.
    RETURN.
  ENDIF.
  WRITE: / 'DEVHUB export 0.3.18 - validation build',
         / 'PASS: UTF-8 Korean round-trip, ZIP ADD/GET, CRC32 vector.',
         / 'PASS: Korean ZIP names and baselines survive SAVE/LOAD.',
         / 'PASS: direct INCLUDE reader fixture.',
         / 'PASS: function source selection fixtures.',
         / 'PASS: raw web bytes and safe filename fixtures.',
         / 'PASS: BSP Properties/Page Attributes XML value bytes.',
         / 'PASS: XML indentation, exact value bytes and corruption detection.',
         / 'PASS: message numbers, placeholders and Korean XML round-trip.',
         / 'Repository read only; all output is ANALYSIS_ONLY.'.
ENDFORM.

FORM create_zip CHANGING co_zip TYPE REF TO cl_abap_zip.
* Public writable ABAP_BOOL in user's active BASIS 700 class metadata.
* Default is ABAP_FALSE: non-ASCII names would otherwise become #.
  CREATE OBJECT co_zip.
  co_zip->support_unicode_names = 'X'.
ENDFORM.

FORM test_zip_names USING po_zip TYPE REF TO cl_abap_zip.
  DATA: lo_in TYPE REF TO cl_abap_conv_in_ce,
        lo_read TYPE REF TO cl_abap_zip,
        lt_names TYPE ty_lines, lv_name TYPE string,
        lv_korean TYPE string, lv_name_bytes TYPE xstring,
        lv_data TYPE xstring, lv_again TYPE xstring,
        lv_archive TYPE xstring, lv_count TYPE i.
* Distinct Korean names would both become "#.bin" in legacy mode.
* Build them from UTF-8 bytes so the REPORT source remains ASCII.
  lv_name_bytes = 'EAB080'.
  CALL METHOD cl_abap_conv_in_ce=>create
    EXPORTING encoding = 'UTF-8' input = lv_name_bytes ignore_cerr = ' '
    RECEIVING conv = lo_in.
  CALL METHOD lo_in->read IMPORTING data = lv_korean.
  CONCATENATE 'content/' lv_korean '.bin' INTO lv_name.
  APPEND lv_name TO lt_names.
  CONCATENATE '.devhub/baseline/content/' lv_korean '.bin'
    INTO lv_name.
  APPEND lv_name TO lt_names.
  lv_name_bytes = 'EB8298'.
  CALL METHOD cl_abap_conv_in_ce=>create
    EXPORTING encoding = 'UTF-8' input = lv_name_bytes ignore_cerr = ' '
    RECEIVING conv = lo_in.
  CALL METHOD lo_in->read IMPORTING data = lv_korean.
  CONCATENATE 'content/' lv_korean '.bin' INTO lv_name.
  APPEND lv_name TO lt_names.
  CONCATENATE '.devhub/baseline/content/' lv_korean '.bin'
    INTO lv_name.
  APPEND lv_name TO lt_names.
  lv_data = '00FF0D0A'.
  LOOP AT lt_names INTO lv_name.
    CALL METHOD po_zip->add EXPORTING name = lv_name content = lv_data.
  ENDLOOP.
* ADD/GET on the same object does not test persisted ZIP filenames.
  CALL METHOD po_zip->save RECEIVING zip = lv_archive.
  PERFORM create_zip CHANGING lo_read.
  CALL METHOD lo_read->load EXPORTING zip = lv_archive
    EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0.
    gv_fatal = 'Korean ZIP filename self-test: LOAD failed'. RETURN.
  ENDIF.
* One existing ASCII selftest plus four new Korean-name entries.
  DESCRIBE TABLE lo_read->files LINES lv_count.
  IF lv_count <> 5.
    gv_fatal = 'Korean ZIP filename self-test: entry count changed'.
    RETURN.
  ENDIF.
  LOOP AT lt_names INTO lv_name.
    READ TABLE lo_read->files WITH KEY name = lv_name
      TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      gv_fatal = 'Korean ZIP filename self-test: stored name changed'.
      RETURN.
    ENDIF.
    CLEAR lv_again.
    CALL METHOD lo_read->get EXPORTING name = lv_name
      IMPORTING content = lv_again EXCEPTIONS OTHERS = 1.
    IF sy-subrc <> 0 OR lv_again <> lv_data.
      gv_fatal = 'Korean ZIP filename self-test: content mismatch'.
      RETURN.
    ENDIF.
  ENDLOOP.
ENDFORM.

FORM resolve_languages.
* Korean first. English is a selective fallback, not a second full export.
  CLEAR gv_language_ko.
  SELECT SINGLE spras FROM t002 INTO gv_language_ko
    WHERE laiso = 'KO'.
  IF sy-subrc <> 0 OR gv_language_ko IS INITIAL.
    gv_fatal = 'T002 mapping for Korean (KO) is missing'. RETURN.
  ENDIF.
  CLEAR gv_language_en.
  SELECT SINGLE spras FROM t002 INTO gv_language_en
    WHERE laiso = 'EN'.
  IF sy-subrc <> 0. CLEAR gv_language_en. ENDIF.
  IF sy-langu <> gv_language_ko.
    gv_fatal = 'Log on in Korean (KO) for APIs without a language parameter'.
    RETURN.
  ENDIF.
  WRITE: / 'T002 language mapping: KO=', gv_language_ko,
           'EN=', gv_language_en, '(KO first; EN fallback)'.
  IF gv_language_en IS INITIAL.
    WRITE: / 'EN mapping unavailable: fallback disabled; KO continues'.
  ENDIF.
ENDFORM.

FORM korean_language CHANGING cv_lang TYPE sy-langu cv_iso TYPE c.
  cv_lang = gv_language_ko. cv_iso = 'KO'.
ENDFORM.

FORM utf8 USING pv_text TYPE string CHANGING cv_data TYPE xstring.
  DATA: lo_out TYPE REF TO cl_abap_conv_out_ce,
        lv_len TYPE i.
  CALL METHOD cl_abap_conv_out_ce=>create
    EXPORTING encoding = 'UTF-8' ignore_cerr = ' '
    RECEIVING conv = lo_out.
  lv_len = strlen( pv_text ).
  CALL METHOD lo_out->convert
    EXPORTING data = pv_text n = lv_len
    IMPORTING buffer = cv_data.
ENDFORM.

FORM segment USING pv_name TYPE c CHANGING cv_segment TYPE string.
  DATA lv_name TYPE string.
  lv_name = pv_name.
  PERFORM safe_leaf USING lv_name CHANGING cv_segment.
ENDFORM.

FORM safe_leaf USING pv_name TYPE string CHANGING cv_leaf TYPE string.
  DATA: lt_parts TYPE STANDARD TABLE OF string,
        lv_base TYPE string, lv_char TYPE c LENGTH 1,
        lv_text TYPE string, lv_empty TYPE string,
        lv_data TYPE xstring, lv_byte TYPE x LENGTH 1,
        lv_hex TYPE c LENGTH 2, lv_i TYPE i, lv_j TYPE i,
        lv_n TYPE i, lv_bytes TYPE i, lv_last TYPE i,
        lv_reserved TYPE c LENGTH 1, lv_escape TYPE c LENGTH 1.
* Preserve names, case, Unicode and extensions; no added prefix.
* Escape only Windows-invalid characters, ~ and reserved device names.
* ~ is always escaped, keeping every ~HH mapping reversible.
  CLEAR cv_leaf.
  lv_n = strlen( pv_name ).
  IF lv_n = 0.
    gv_fatal = 'Empty archive name cannot be represented'. RETURN.
  ENDIF.
  SPLIT pv_name AT '.' INTO TABLE lt_parts.
  READ TABLE lt_parts INTO lv_base INDEX 1.
  TRANSLATE lv_base TO UPPER CASE.
  CONDENSE lv_base.
  IF lv_base = 'CON' OR lv_base = 'PRN' OR lv_base = 'AUX' OR
     lv_base = 'NUL' OR lv_base = 'CONIN$' OR lv_base = 'CONOUT$'.
    lv_reserved = 'X'.
  ELSEIF strlen( lv_base ) = 4.
    IF lv_base(3) = 'COM' OR lv_base(3) = 'LPT'.
      IF lv_base+3(1) CA '123456789'. lv_reserved = 'X'. ENDIF.
      lv_text = lv_base+3(1).
      PERFORM utf8 USING lv_text CHANGING lv_data.
      IF lv_data = 'C2B9' OR lv_data = 'C2B2' OR lv_data = 'C2B3'.
        lv_reserved = 'X'.
      ENDIF.
    ENDIF.
  ENDIF.
* Encode the whole terminal run of dots/spaces, not just its final byte.
  lv_last = lv_n.
  WHILE lv_last > 0.
    lv_i = lv_last - 1. lv_char = pv_name+lv_i(1).
    IF lv_char <> '.' AND lv_char <> space. EXIT. ENDIF.
    SUBTRACT 1 FROM lv_last.
  ENDWHILE.
  DO lv_n TIMES.
    lv_i = sy-index - 1. lv_char = pv_name+lv_i(1).
    CLEAR lv_escape.
    IF lv_char CA '<>:"/\|?*~' OR lv_char < space OR
       lv_i >= lv_last OR ( lv_i = 0 AND lv_reserved = 'X' ).
      lv_escape = 'X'.
    ENDIF.
    CONCATENATE lv_char lv_empty INTO lv_text RESPECTING BLANKS.
* DEL is rejected by the offline checker as well.
    IF lv_char BETWEEN ' ' AND '~'.
* Printable ASCII has already been classified above.
    ELSE.
      PERFORM utf8 USING lv_text CHANGING lv_data.
      IF lv_data = '7F'. lv_escape = 'X'. ENDIF.
    ENDIF.
    IF lv_escape = 'X'.
      PERFORM utf8 USING lv_text CHANGING lv_data.
      lv_bytes = xstrlen( lv_data ).
      DO lv_bytes TIMES.
        lv_j = sy-index - 1. lv_byte = lv_data+lv_j(1).
        lv_hex = lv_byte.
        CONCATENATE cv_leaf '~' lv_hex INTO cv_leaf.
      ENDDO.
    ELSE.
      CONCATENATE cv_leaf lv_text INTO cv_leaf RESPECTING BLANKS.
    ENDIF.
  ENDDO.
ENDFORM.

FORM discover.
  DATA: lt_child TYPE STANDARD TABLE OF ty_package,
        ls_child TYPE ty_package,
        ls_def TYPE tdevc,
        lt_obj TYPE STANDARD TABLE OF ty_object,
        lv_i TYPE i,
        lv_where TYPE string.
  FIELD-SYMBOLS: <lv_parent> TYPE ANY.
  gv_stage = 'DISCOVER'.
  SELECT devclass FROM tdevc INTO TABLE gt_packages
    WHERE devclass IN s_pack.
  IF gt_packages IS INITIAL.
    gv_fatal = 'No matching package'.
    RETURN.
  ENDIF.
  SORT gt_packages BY devclass.
* Count selected roots, not the automatically included child packages.
  PERFORM archive_filename USING gt_packages CHANGING gv_archive_name.
  IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  LOOP AT gt_packages INTO gs_package.
    INSERT gs_package INTO TABLE gt_seen_pkg.
  ENDLOOP.
  IF p_sub = 'X'.
    ASSIGN COMPONENT 'PARENTCL' OF STRUCTURE ls_def TO <lv_parent>.
    IF sy-subrc <> 0.
      gv_fatal = 'TDEVC hierarchy field missing'.
      RETURN.
    ENDIF.
    lv_where = 'PARENTCL = GS_PACKAGE-DEVCLASS'.
    lv_i = 1.
    DO.
      READ TABLE gt_packages INTO gs_package INDEX lv_i.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.
      SELECT devclass FROM tdevc INTO TABLE lt_child
        WHERE (lv_where).
      SORT lt_child BY devclass.
      LOOP AT lt_child INTO ls_child.
        INSERT ls_child INTO TABLE gt_seen_pkg.
        IF sy-subrc = 0.
          APPEND ls_child TO gt_packages.
        ENDIF.
      ENDLOOP.
      ADD 1 TO lv_i.
    ENDDO.
  ENDIF.
  SORT gt_packages BY devclass.
  LOOP AT gt_packages INTO gs_package.
    SELECT pgmid object obj_name devclass FROM tadir
      INTO CORRESPONDING FIELDS OF TABLE lt_obj
      WHERE devclass = gs_package-devclass.
    APPEND LINES OF lt_obj TO gt_objects.
  ENDLOOP.
  SORT gt_objects BY devclass pgmid object obj_name.
  DELETE ADJACENT DUPLICATES FROM gt_objects
    COMPARING devclass pgmid object obj_name.
  DESCRIBE TABLE gt_objects LINES gv_count.
  WRITE: / 'Catalog entries:', gv_count.
ENDFORM.

FORM check_auth USING pv_type TYPE c pv_name TYPE c pv_pkg TYPE c
                CHANGING cv_ok TYPE c.
  CLEAR cv_ok.
  AUTHORITY-CHECK OBJECT 'S_DEVELOP'
    ID 'ACTVT' FIELD '03'
    ID 'DEVCLASS' FIELD pv_pkg
    ID 'OBJTYPE' FIELD pv_type
    ID 'OBJNAME' FIELD pv_name
    ID 'P_GROUP' DUMMY.
  IF sy-subrc = 0.
    cv_ok = 'X'.
  ENDIF.
ENDFORM.

FORM export_object.
  DATA: lv_pkg TYPE string,
        lv_name TYPE string,
        lv_folder TYPE string, lv_kind TYPE string.
* Class bodies and reference diagnostics are outside this analysis scope.
* Keep the discovered catalog row, but do not read/check class bodies.
  IF gs_object-object = 'CLAS'.
    gs_object-status = 'UNSUPPORTED'.
    gs_object-reason = 'Class source not exported; reference diagnostics off'.
    RETURN.
  ENDIF.
  IF gs_object-object = 'SMIM'.
    READ TABLE gt_done_smim WITH TABLE KEY table_line =
      gs_object-obj_name TRANSPORTING NO FIELDS.
    IF sy-subrc = 0. RETURN. ENDIF.
    INSERT gs_object-obj_name INTO TABLE gt_done_smim.
  ENDIF.
  gv_stage = 'OBJECT'.
  gv_component = gs_object-obj_name.
  PERFORM check_auth USING gs_object-object gs_object-obj_name
    gs_object-devclass CHANGING gv_ok.
  IF gv_ok IS INITIAL.
    gs_object-status = 'FAILED'.
    gs_object-reason = 'S_DEVELOP display authorization denied'.
    RETURN.
  ENDIF.
  CASE gs_object-object.
    WHEN 'PROG'. lv_folder = 'programs'.
    WHEN 'FUGR'. lv_folder = 'function-groups'.
    WHEN 'MSAG'. lv_folder = 'MessageClass'.
    WHEN 'WAPA'. lv_folder = 'BSP Application'.
    WHEN 'SMIM' OR 'W3MI'. lv_folder = 'MIME'.
    WHEN 'TABL' OR 'DTEL' OR 'DOMA' OR 'VIEW' OR 'TTYP' OR 'SHLP'.
      lv_folder = 'Dictionary Object'.
    WHEN OTHERS.
      gs_object-status = 'UNSUPPORTED'.
      gs_object-reason = 'Cataloged; serializer not implemented in 0.3.18'.
      RETURN.
  ENDCASE.
  PERFORM segment USING gs_object-devclass CHANGING lv_pkg.
  PERFORM segment USING gs_object-obj_name CHANGING lv_name.
  lv_kind = gs_object-object.
  IF gs_object-object = 'TTYP'. lv_kind = 'TableType'. ENDIF.
  IF gs_object-object = 'DOMA'. lv_kind = 'Domain'. ENDIF.
  IF gs_object-object = 'DTEL'. lv_kind = 'Data element'. ENDIF.
  CONCATENATE 'packages/' lv_pkg '/' lv_folder '/'
    lv_kind '/' lv_name '/' INTO gv_root.
  IF gs_object-object = 'SMIM'.
    CONCATENATE 'packages/' lv_pkg '/MIME/' INTO gv_root.
  ENDIF.
  IF gs_object-object = 'MSAG'.
    CONCATENATE 'packages/' lv_pkg '/MessageClass/' lv_name '/'
      INTO gv_root.
  ENDIF.
  gs_object-status = 'PARTIAL'.
  IF gs_object-object = 'PROG'.
    gs_object-reason =
      'Active source/text/attributes only; screens/GUI not serialized'.
    PERFORM export_program.
  ELSEIF gs_object-object = 'FUGR'.
    gs_object-reason =
      'Function API U; owned include walk partial; screens/docs incomplete'.
    PERFORM export_function_group.
  ELSEIF gs_object-object = 'MSAG'.
    PERFORM export_message_class.
  ELSEIF gs_object-object = 'WAPA'.
    PERFORM export_bsp.
  ELSEIF gs_object-object = 'SMIM'.
    PERFORM export_smim.
  ELSEIF gs_object-object = 'W3MI'.
    PERFORM export_w3mi.
  ELSE.
    gs_object-reason =
      'Active DDIC API output; completeness and dependency review pending'.
    PERFORM export_ddic.
  ENDIF.
ENDFORM.

FORM export_message_class.
  DATA: lv_class TYPE t100-arbgb, lv_exists TYPE t100a-arbgb,
        lt_messages TYPE ty_messages, lt_english TYPE ty_messages,
        ls_english TYPE t100, lv_fallback TYPE i, lv_ko_count TYPE i,
        lv_fallback_text TYPE c LENGTH 12, lv_xml TYPE xstring,
        lv_error TYPE string, lv_count TYPE i,
        lv_count_text TYPE c LENGTH 12, lv_detail TYPE string.
  gv_stage = 'MSAG_READ'.
* Called only for selected R3TR MSAG entries after S_DEVELOP display
* authorization. Do not follow MESSAGE statements into other packages.
  lv_class = gs_object-obj_name.
  IF lv_class IS INITIAL OR lv_class <> gs_object-obj_name.
    gs_object-status = 'FAILED'.
    gs_object-reason = 'Message class name is empty or would be truncated'.
    PERFORM log USING gv_stage 'FAILED' gs_object-reason. RETURN.
  ENDIF.
  SELECT SINGLE arbgb FROM t100a INTO lv_exists
    WHERE arbgb = lv_class.
  IF sy-subrc <> 0.
    gs_object-status = 'FAILED'.
    gs_object-reason = 'Registered message class has no T100A header'.
    PERFORM log USING gv_stage 'FAILED' gs_object-reason. RETURN.
  ENDIF.
* Use the Korean key resolved from T002, never a hard-coded K or 3.
* SELECT only message definitions; no application/business records.
  SELECT * FROM t100 INTO TABLE lt_messages
    WHERE arbgb = lv_class AND sprsl = gv_language_ko.
  DESCRIBE TABLE lt_messages LINES lv_ko_count.
  IF gv_language_en IS NOT INITIAL.
    SELECT * FROM t100 INTO TABLE lt_english
      WHERE arbgb = lv_class AND sprsl = gv_language_en.
    LOOP AT lt_english INTO ls_english.
* Missing NUMBER only: even an intentionally blank Korean row wins.
      READ TABLE lt_messages WITH KEY msgnr = ls_english-msgnr
        TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        APPEND ls_english TO lt_messages. ADD 1 TO lv_fallback.
      ENDIF.
    ENDLOOP.
  ENDIF.
  SORT lt_messages BY msgnr.
  PERFORM message_xml USING lv_class gs_object-devclass gv_language_ko
    lt_messages CHANGING lv_xml lv_error.
  IF lv_error IS NOT INITIAL.
    gs_object-status = 'FAILED'. gs_object-reason = lv_error.
    PERFORM log USING gv_stage 'FAILED' lv_error. RETURN.
  ENDIF.
  gv_file_language = gv_language_ko.
  IF lv_fallback > 0.
    IF lv_ko_count = 0. gv_file_language = gv_language_en.
    ELSE. CLEAR gv_file_language. ENDIF.
    WRITE lv_fallback TO lv_fallback_text. CONDENSE lv_fallback_text.
    CONCATENATE 'MSAG missing Korean numbers filled from EN:'
      lv_fallback_text INTO lv_detail SEPARATED BY space.
    PERFORM log USING 'LANGUAGE_FALLBACK' 'INFO' lv_detail.
  ENDIF.
* Current T100 rows are read directly, not through an explicit STATE=A API.
  gv_payload_state = 'U'.
  PERFORM add_file USING 'Messages.xml' 'MESSAGE_SHORT_TEXTS' lv_xml.
  CLEAR: gv_file_language, gv_payload_state.
  IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  gs_object-status = 'PARTIAL'.
  gs_object-reason =
    'KO-first T100 short texts; missing numbers use EN; no long texts; U'.
  DESCRIBE TABLE lt_messages LINES lv_count.
  WRITE lv_count TO lv_count_text. CONDENSE lv_count_text.
  CONCATENATE 'Short messages=' lv_count_text
    '; KO first; EN for missing numbers; long texts not exported'
    INTO lv_detail.
  PERFORM log USING 'MSAG_SUMMARY' 'INFO' lv_detail.
ENDFORM.

FORM message_xml USING pv_class TYPE t100-arbgb
                       pv_package TYPE tadir-devclass
                       pv_language TYPE sy-langu
                       pt_messages TYPE ty_messages
                 CHANGING cv_xml TYPE xstring cv_error TYPE string.
  DATA: lv_raw TYPE xstring, lv_count TYPE i, lv_count_check TYPE i,
        lv_class_check TYPE t100-arbgb,
        lv_package_check TYPE tadir-devclass,
        lv_language_check TYPE sy-langu,
        lv_long_texts TYPE c LENGTH 1, lv_long_check TYPE c LENGTH 1,
        lt_check TYPE ty_messages, lo_error TYPE REF TO cx_root.
  CLEAR: cv_xml, cv_error.
  DESCRIBE TABLE pt_messages LINES lv_count.
  TRY.
      CALL TRANSFORMATION id SOURCE message_class = pv_class
        development_class = pv_package requested_language = pv_language
        message_count = lv_count long_texts_included = lv_long_texts
        messages = pt_messages RESULT XML lv_raw.
      PERFORM pretty_xml USING lv_raw CHANGING cv_xml cv_error.
      IF cv_error IS NOT INITIAL. RETURN. ENDIF.
* Verify NUMC message numbers, literal ampersands and Korean text after
* XML rendering. Never substitute runtime variables or renumber gaps.
      CALL TRANSFORMATION id SOURCE XML cv_xml
        RESULT message_class = lv_class_check
          development_class = lv_package_check
          requested_language = lv_language_check
          message_count = lv_count_check long_texts_included = lv_long_check
          messages = lt_check.
      IF lv_class_check <> pv_class OR lv_package_check <> pv_package
        OR lv_language_check <> pv_language OR lv_count_check <> lv_count
        OR lv_long_check <> lv_long_texts OR lt_check <> pt_messages.
        CLEAR cv_xml.
        cv_error = 'Message XML round-trip changed numbers or texts'.
      ENDIF.
    CATCH cx_root INTO lo_error.
      CLEAR cv_xml. cv_error = lo_error->get_text( ).
  ENDTRY.
ENDFORM.

FORM test_message_xml USING pv_korean TYPE string.
  DATA: lt_messages TYPE ty_messages, ls_message TYPE t100,
        lv_class TYPE t100-arbgb, lv_package TYPE tadir-devclass,
        lv_xml TYPE xstring, lv_error TYPE string.
  lv_class = 'DEVHUB_SELFTEST'. lv_package = '$TMP'.
  ls_message-sprsl = gv_language_ko. ls_message-arbgb = lv_class.
  ls_message-msgnr = '000'. ls_message-text = '& & & &'.
  APPEND ls_message TO lt_messages.
  ls_message-msgnr = '004'.
  CONCATENATE '&1' pv_korean '&2 &3 &4 < > "quotes"'
    INTO ls_message-text SEPARATED BY space.
  APPEND ls_message TO lt_messages.
  ls_message-msgnr = '061'. CLEAR ls_message-text.
  APPEND ls_message TO lt_messages.
  PERFORM message_xml USING lv_class lv_package gv_language_ko
    lt_messages CHANGING lv_xml lv_error.
  IF lv_error IS NOT INITIAL. gv_fatal = lv_error. RETURN. ENDIF.
  REFRESH lt_messages.
  PERFORM message_xml USING lv_class lv_package gv_language_ko
    lt_messages CHANGING lv_xml lv_error.
  IF lv_error IS NOT INITIAL. gv_fatal = lv_error. ENDIF.
ENDFORM.

FORM skip_object USING pv_stage TYPE c pv_detail TYPE csequence.
* A known omission is neither a successful export nor a failed run.
  gs_object-status = 'SKIPPED'.
  gs_object-reason = pv_detail.
  PERFORM log USING pv_stage 'WARNING' pv_detail.
ENDFORM.

FORM object_error USING po_error TYPE REF TO cx_root.
  DATA: lo_current TYPE REF TO cx_root,
        lo_serial TYPE REF TO cx_xslt_serialization_error,
        lv_ddic TYPE c LENGTH 1.
  CASE gs_object-object.
    WHEN 'TABL' OR 'DTEL' OR 'DOMA' OR 'VIEW' OR 'TTYP' OR 'SHLP'.
      lv_ddic = 'X'.
  ENDCASE.
  IF lv_ddic = 'X'.
* A kernel/API wrapper can carry the original exception in PREVIOUS.
* Use exception types, never translated message text, to classify it.
    lo_current = po_error.
    DO 16 TIMES.
      IF lo_current IS INITIAL. EXIT. ENDIF.
      TRY.
          lo_serial ?= lo_current.
          PERFORM skip_object USING 'DDIC_XML'
            'DDIC definition omitted: CX_XSLT_SERIALIZATION_ERROR'.
          RETURN.
        CATCH cx_sy_move_cast_error.
* Unrelated exceptions remain failures after the cause-chain check.
      ENDTRY.
      lo_current = lo_current->previous.
    ENDDO.
  ENDIF.
  gv_error = po_error->get_text( ).
  gs_object-status = 'FAILED'.
  gs_object-reason = gv_error.
  PERFORM log USING gv_stage 'FAILED' gv_error.
ENDFORM.

FORM log USING pv_stage TYPE c pv_status TYPE c
               pv_detail TYPE csequence.
  DATA: ls_log TYPE ty_log.
  ls_log-object = gs_object-object.
  ls_log-obj_name = gs_object-obj_name.
  ls_log-stage = pv_stage.
  ls_log-component = gv_component.
  ls_log-status = pv_status.
  ls_log-detail = pv_detail.
  APPEND ls_log TO gt_logs.
ENDFORM.

FORM add_raw USING pv_path TYPE string pv_data TYPE xstring.
  DATA: lv_size TYPE i,
        lv_total TYPE i,
        lv_path_key TYPE string.
  IF gv_fatal IS NOT INITIAL.
    RETURN.
  ENDIF.
  IF strlen( pv_path ) > 220.
    gv_fatal = 'Archive path exceeds 220 characters; no truncation used'.
    RETURN.
  ENDIF.
* Windows paths are case-insensitive: reject collisions before download.
  lv_path_key = pv_path.
  TRANSLATE lv_path_key TO UPPER CASE.
  INSERT lv_path_key INTO TABLE gt_paths.
  IF sy-subrc <> 0.
    CONCATENATE 'Duplicate/case-colliding archive path:' pv_path INTO gv_fatal
      SEPARATED BY space.
    RETURN.
  ENDIF.
  lv_size = xstrlen( pv_data ).
  IF lv_size > 16777216.
    gv_fatal = 'File exceeds 16 MiB validation-build limit'.
    RETURN.
  ENDIF.
  lv_total = gv_bytes + lv_size.
  IF lv_total > gv_maxbytes.
    gv_fatal = 'Uncompressed ZIP budget exceeded; narrow the selection'.
    RETURN.
  ENDIF.
  CALL METHOD go_zip->add EXPORTING name = pv_path content = pv_data.
  gv_bytes = gv_bytes + lv_size.
ENDFORM.

FORM add_file USING pv_relative TYPE csequence
                    pv_component TYPE csequence
                    pv_data TYPE xstring.
  DATA: ls_file TYPE ty_file, lv_data TYPE xstring,
        lv_error TYPE string.
  IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  lv_data = pv_data.
* Format generated metadata before checksums and BOTH ZIP copies.
* RAW web/MIME assets retain their exact bytes, including *.xml assets.
  IF pv_relative CP '*.xml' AND gv_check_mode <> 'RAW'.
    PERFORM pretty_xml USING pv_data CHANGING lv_data lv_error.
    IF lv_error IS NOT INITIAL.
      CONCATENATE 'XML formatting failed:' pv_relative lv_error
        INTO gv_fatal SEPARATED BY space.
      RETURN.
    ENDIF.
  ENDIF.
  CONCATENATE gv_root pv_relative INTO ls_file-path.
  CONCATENATE '.devhub/baseline/' ls_file-path INTO ls_file-baseline.
  ls_file-devclass = gs_object-devclass.
  ls_file-object = gs_object-object.
  ls_file-obj_name = gs_object-obj_name.
  ls_file-component = pv_component.
  ls_file-language = gv_file_language.
  ls_file-active_state = 'A'.
  IF gv_payload_state IS NOT INITIAL.
    ls_file-active_state = gv_payload_state.
  ENDIF.
  IF pv_component = 'TRDIR_CATALOG'.
    ls_file-active_state = 'U'.
  ENDIF.
  ls_file-byte_length = xstrlen( lv_data ).
  ls_file-checksum_algorithm = 'CRC32-SIGNED-INT32'.
  CALL METHOD cl_abap_zip=>crc32
    EXPORTING content = lv_data RECEIVING crc32 = ls_file-checksum.
  ls_file-capability = 'ANALYSIS_ONLY'.
  ls_file-check_mode = 'LF_UTF8'.
  IF gv_check_mode IS NOT INITIAL.
    ls_file-check_mode = gv_check_mode.
  ENDIF.
  PERFORM add_raw USING ls_file-path lv_data.
  PERFORM add_raw USING ls_file-baseline lv_data.
  IF gv_fatal IS INITIAL.
    APPEND ls_file TO gt_files.
  ENDIF.
ENDFORM.

FORM pretty_xml USING pv_data TYPE xstring
                CHANGING cv_data TYPE xstring cv_error TYPE string.
* Only generated, element-only asXML is accepted here. RAW web assets
* bypass this routine. Copy tag and leaf-text bytes without decoding or
* normalizing them; add indentation ONLY between structural elements.
  DATA: lt_chunks TYPE STANDARD TABLE OF xstring,
        lv_chunk TYPE xstring, lv_size TYPE i, lv_pos TYPE i, lv_start TYPE i,
        lv_after TYPE i, lv_len TYPE i, lv_i TYPE i, lv_last TYPE i,
        lv_depth TYPE i, lv_kind TYPE c, lv_previous TYPE c,
        lv_byte TYPE x LENGTH 1, lv_quote TYPE x LENGTH 1,
        lv_gap TYPE xstring, lv_tag TYPE xstring,
        lv_lf TYPE x LENGTH 1 VALUE '0A',
        lv_spaces TYPE x LENGTH 2 VALUE '2020',
        lv_end TYPE c, lv_leaf TYPE c, lv_seen TYPE c.
  CLEAR: cv_data, cv_error.
  lv_size = xstrlen( pv_data ).
  IF lv_size >= 3.
    IF pv_data(3) = 'EFBBBF'.
      lv_chunk = pv_data(3). APPEND lv_chunk TO lt_chunks. lv_pos = 3.
    ENDIF.
  ENDIF.
  WHILE lv_pos < lv_size.
    lv_start = lv_pos.
    WHILE lv_pos < lv_size.
      lv_byte = pv_data+lv_pos(1).
      IF lv_byte = '3C'. EXIT. ENDIF.
      ADD 1 TO lv_pos.
    ENDWHILE.
    lv_len = lv_pos - lv_start.
    lv_gap = pv_data+lv_start(lv_len).
    IF lv_pos = lv_size.
* Only whitespace may follow the root. Leave leaf values untouched.
      DO lv_len TIMES.
        lv_i = sy-index - 1. lv_byte = lv_gap+lv_i(1).
        IF lv_byte <> '20' AND lv_byte <> '09' AND
           lv_byte <> '0A' AND lv_byte <> '0D'.
          cv_error = 'Unexpected text after generated XML root'. EXIT.
        ENDIF.
      ENDDO.
      EXIT.
    ENDIF.
    lv_start = lv_pos. ADD 1 TO lv_pos.
    CLEAR: lv_quote, lv_end.
    WHILE lv_pos < lv_size.
      lv_byte = pv_data+lv_pos(1).
      IF lv_quote IS NOT INITIAL.
        IF lv_byte = lv_quote. CLEAR lv_quote. ENDIF.
      ELSEIF lv_byte = '22' OR lv_byte = '27'.
        lv_quote = lv_byte.
      ELSEIF lv_byte = '3E'.
        lv_end = 'X'. ADD 1 TO lv_pos. EXIT.
      ENDIF.
      ADD 1 TO lv_pos.
    ENDWHILE.
    IF lv_end IS INITIAL.
      cv_error = 'Unterminated generated XML tag'. EXIT.
    ENDIF.
    lv_after = lv_pos.
    lv_len = lv_after - lv_start.
    lv_tag = pv_data+lv_start(lv_len).
    IF lv_len < 3.
      cv_error = 'Invalid generated XML tag'. EXIT.
    ENDIF.
    lv_byte = lv_tag+1(1). lv_kind = 'O'.
    IF lv_byte = '2F'.
      lv_kind = 'C'.
    ELSEIF lv_byte = '3F'.
      lv_kind = 'P'.
    ELSEIF lv_byte = '21'.
      cv_error = 'Declarations or CDATA are not generated asXML'. EXIT.
    ELSE.
      lv_last = lv_len - 2. lv_byte = lv_tag+lv_last(1).
      IF lv_byte = '2F'. lv_kind = 'S'. ENDIF.
    ENDIF.
    IF lv_kind = 'C'. SUBTRACT 1 FROM lv_depth. ENDIF.
    IF lv_depth < 0.
      cv_error = 'Unbalanced generated XML tags'. EXIT.
    ENDIF.
    CLEAR lv_leaf.
    IF lv_previous = 'O' AND lv_kind = 'C'. lv_leaf = 'X'. ENDIF.
    IF lv_leaf = 'X'.
* Includes empty values, all-space strings, CR/LF, entities and UTF-8.
      APPEND lv_gap TO lt_chunks.
    ELSE.
      lv_len = xstrlen( lv_gap ).
      DO lv_len TIMES.
        lv_i = sy-index - 1. lv_byte = lv_gap+lv_i(1).
        IF lv_byte <> '20' AND lv_byte <> '09' AND
           lv_byte <> '0A' AND lv_byte <> '0D'.
          cv_error = 'Mixed content is not generated element-only asXML'.
          EXIT.
        ENDIF.
      ENDDO.
      IF cv_error IS NOT INITIAL. EXIT. ENDIF.
      IF lv_seen = 'X'.
        lv_chunk = lv_lf. APPEND lv_chunk TO lt_chunks.
        DO lv_depth TIMES.
          lv_chunk = lv_spaces. APPEND lv_chunk TO lt_chunks.
        ENDDO.
      ENDIF.
    ENDIF.
    APPEND lv_tag TO lt_chunks.
    IF lv_kind = 'O'. ADD 1 TO lv_depth. ENDIF.
    lv_previous = lv_kind. lv_seen = 'X'.
  ENDWHILE.
  IF cv_error IS INITIAL AND ( lv_depth <> 0 OR lv_seen IS INITIAL ).
    cv_error = 'Incomplete generated XML document'.
  ENDIF.
  IF cv_error IS INITIAL.
    CONCATENATE LINES OF lt_chunks INTO cv_data IN BYTE MODE.
    PERFORM verify_xml_values USING pv_data cv_data CHANGING cv_error.
    IF cv_error IS NOT INITIAL. CLEAR cv_data. ENDIF.
  ENDIF.
ENDFORM.

FORM xml_value_bytes USING pv_xml TYPE xstring
                     CHANGING cv_bytes TYPE xstring cv_error TYPE string.
* Validation view of generated element-only asXML, independent of output
* indentation: keep ALL tag bytes and ALL leaf text, including only blanks.
* No ID deserialization: SAP documents that it is not symmetric for
* strings containing only blanks. This routine never rewrites output XML.
  DATA: lt_parts TYPE STANDARD TABLE OF xstring,
        lv_part TYPE xstring, lv_tag TYPE xstring,
        lv_n TYPE i, lv_p TYPE i, lv_start TYPE i, lv_len TYPE i,
        lv_last TYPE i, lv_next TYPE i, lv_i TYPE i,
        lv_char TYPE x LENGTH 1, lv_quote TYPE x LENGTH 1,
        lv_open TYPE c, lv_leaf TYPE c, lv_end TYPE c.
  CLEAR: cv_bytes, cv_error.
  lv_n = xstrlen( pv_xml ).
  IF lv_n >= 3.
    IF pv_xml(3) = 'EFBBBF'.
      lv_part = pv_xml(3). APPEND lv_part TO lt_parts. lv_p = 3.
    ENDIF.
  ENDIF.
  WHILE lv_p < lv_n.
* Leading whitespace is structural. Non-whitespace before a tag is invalid.
    lv_char = pv_xml+lv_p(1).
    IF lv_char = '20' OR lv_char = '09' OR
       lv_char = '0A' OR lv_char = '0D'.
      ADD 1 TO lv_p. CONTINUE.
    ENDIF.
    IF lv_char <> '3C'.
      cv_error = 'XML_VERIFY expected a tag'. EXIT.
    ENDIF.
    lv_start = lv_p. ADD 1 TO lv_p.
    CLEAR: lv_quote, lv_end.
    WHILE lv_p < lv_n.
      lv_char = pv_xml+lv_p(1).
      ADD 1 TO lv_p.
      IF lv_quote IS NOT INITIAL.
        IF lv_char = lv_quote. CLEAR lv_quote. ENDIF.
      ELSE.
        CASE lv_char.
          WHEN '22' OR '27'. lv_quote = lv_char.
          WHEN '3E'. lv_end = 'X'. EXIT.
        ENDCASE.
      ENDIF.
    ENDWHILE.
    IF lv_end IS INITIAL.
      cv_error = 'XML_VERIFY unterminated tag'. EXIT.
    ENDIF.
    lv_len = lv_p - lv_start.
    IF lv_len < 3.
      cv_error = 'XML_VERIFY invalid tag'. EXIT.
    ENDIF.
    lv_tag = pv_xml+lv_start(lv_len). APPEND lv_tag TO lt_parts.
    lv_last = lv_len - 2. lv_open = 'X'.
    IF lv_tag+1(1) = '2F' OR lv_tag+1(1) = '3F'
       OR lv_tag+lv_last(1) = '2F'. CLEAR lv_open. ENDIF.
    IF lv_tag+1(1) = '21'.
      cv_error = 'XML_VERIFY unsupported generated XML declaration'. EXIT.
    ENDIF.
* Read the following text span. A leaf is an opening tag immediately
* followed by its closing tag, with any text between them significant.
    lv_start = lv_p.
    WHILE lv_p < lv_n.
      IF pv_xml+lv_p(1) = '3C'. EXIT. ENDIF.
      ADD 1 TO lv_p.
    ENDWHILE.
    lv_len = lv_p - lv_start. lv_part = pv_xml+lv_start(lv_len).
    lv_next = lv_p + 1. CLEAR lv_leaf.
    IF lv_open = 'X' AND lv_next < lv_n.
      IF pv_xml+lv_next(1) = '2F'. lv_leaf = 'X'. ENDIF.
    ENDIF.
    IF lv_leaf = 'X'.
      APPEND lv_part TO lt_parts.
    ELSE.
      DO lv_len TIMES.
        lv_i = sy-index - 1. lv_char = lv_part+lv_i(1).
        IF lv_char <> '20' AND lv_char <> '09' AND
           lv_char <> '0A' AND lv_char <> '0D'.
          cv_error = 'XML_VERIFY unexpected non-leaf text'. EXIT.
        ENDIF.
      ENDDO.
      IF cv_error IS NOT INITIAL. EXIT. ENDIF.
    ENDIF.
  ENDWHILE.
  IF cv_error IS INITIAL.
    CONCATENATE LINES OF lt_parts INTO cv_bytes IN BYTE MODE.
  ENDIF.
ENDFORM.

FORM verify_xml_values USING pv_before TYPE xstring pv_after TYPE xstring
                       CHANGING cv_error TYPE string.
  DATA: lv_before TYPE xstring, lv_after TYPE xstring,
        lv_before_size TYPE i, lv_after_size TYPE i,
        lv_limit TYPE i, lv_offset TYPE i,
        lv_number TYPE c LENGTH 12.
  CLEAR cv_error.
  PERFORM xml_value_bytes USING pv_before CHANGING lv_before cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  PERFORM xml_value_bytes USING pv_after CHANGING lv_after cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  IF lv_before = lv_after. RETURN. ENDIF.
  lv_before_size = xstrlen( lv_before ).
  lv_after_size = xstrlen( lv_after ).
  lv_limit = lv_before_size.
  IF lv_after_size < lv_limit. lv_limit = lv_after_size. ENDIF.
  WHILE lv_offset < lv_limit.
    IF lv_before+lv_offset(1) <> lv_after+lv_offset(1). EXIT. ENDIF.
    ADD 1 TO lv_offset.
  ENDWHILE.
  WRITE lv_offset TO lv_number. CONDENSE lv_number.
  CONCATENATE 'XML_VERIFY tag/value bytes changed at offset' lv_number
    INTO cv_error SEPARATED BY space.
ENDFORM.

FORM add_xml_raw USING pv_path TYPE string pv_data TYPE xstring.
  DATA: lv_data TYPE xstring, lv_error TYPE string.
  IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  PERFORM pretty_xml USING pv_data CHANGING lv_data lv_error.
  IF lv_error IS NOT INITIAL.
    CONCATENATE 'XML formatting failed:' pv_path lv_error
      INTO gv_fatal SEPARATED BY space.
    RETURN.
  ENDIF.
  PERFORM add_raw USING pv_path lv_data.
ENDFORM.

FORM test_pretty_xml USING pv_korean TYPE string.
  TYPES: BEGIN OF ty_fixture,
           text TYPE string, blanks TYPE string, fixed TYPE c LENGTH 12,
           amount TYPE p LENGTH 8 DECIMALS 2, flag TYPE c LENGTH 1,
         END OF ty_fixture.
  DATA: ls_before TYPE ty_fixture,
        lt_before TYPE STANDARD TABLE OF ty_fixture,
        lv_raw TYPE xstring, lv_pretty TYPE xstring,
        lv_error TYPE string, lv_empty TYPE string,
        lv_blank_xml TYPE xstring, lv_bad_xml TYPE xstring,
        lv_pass TYPE c LENGTH 1,
        lv_indent TYPE x LENGTH 2 VALUE '0A20',
        lo_error TYPE REF TO cx_root.
  CONCATENATE '  ' pv_korean '<tag>&"quoted"' gv_lf '  tail  '
    lv_empty INTO ls_before-text RESPECTING BLANKS.
  CONCATENATE '   ' lv_empty INTO ls_before-blanks RESPECTING BLANKS.
  ls_before-fixed = '  000123'.
  ls_before-amount = '-123.40'. ls_before-flag = 'X'.
  APPEND ls_before TO lt_before.
  CLEAR ls_before. APPEND ls_before TO lt_before.
  TRY.
      CALL TRANSFORMATION id SOURCE rows = lt_before
        RESULT XML lv_raw.
* ID is not symmetric for an all-space STRING. The reference here is
* the raw asXML delivered by SAP, not an assumed ABAP inverse. A separate
* literal XML fixture below proves that the formatter preserves spaces.
* Exercise compact and already-indented input; tab XML is formatted
* once in a tab helper and again by the shared archive writer.
      DO 2 TIMES.
        lv_pass = sy-index.
        PERFORM pretty_xml USING lv_raw CHANGING lv_pretty lv_error.
        IF lv_error IS NOT INITIAL.
          gv_fatal = lv_error. RETURN.
        ENDIF.
        FIND FIRST OCCURRENCE OF lv_indent IN lv_pretty IN BYTE MODE.
        IF sy-subrc <> 0.
          gv_fatal = 'Generated XML has no indented line breaks'. RETURN.
        ENDIF.
        PERFORM verify_xml_values USING lv_raw lv_pretty
          CHANGING lv_error.
        IF lv_error IS NOT INITIAL.
          CONCATENATE 'XML_SELFTEST pass' lv_pass lv_error
            INTO gv_fatal SEPARATED BY space. RETURN.
        ENDIF.
        lv_raw = lv_pretty.
      ENDDO.
* Literal XML avoids using ID as an oracle for its documented blank case.
      lv_blank_xml = '3C523E3C563E2020203C2F563E3C2F523E'.
      PERFORM pretty_xml USING lv_blank_xml
        CHANGING lv_pretty lv_error.
      IF lv_error IS NOT INITIAL. gv_fatal = lv_error. RETURN. ENDIF.
      lv_bad_xml = '3C563E2020203C2F563E'.
      FIND FIRST OCCURRENCE OF lv_bad_xml IN lv_pretty IN BYTE MODE.
      IF sy-subrc <> 0.
        gv_fatal = 'XML_SELFTEST formatting lost BLANKS (3 spaces)'.
        RETURN.
      ENDIF.
* Prove the verifier rejects the exact data loss that ID can conceal:
* three spaces becoming an empty element. Expected failure stays local.
      lv_blank_xml = '3C523E3C563E2020203C2F563E3C2F523E'.
      lv_bad_xml = '3C523E3C563E3C2F563E3C2F523E'.
      PERFORM verify_xml_values USING lv_blank_xml lv_bad_xml
        CHANGING lv_error.
      IF lv_error IS INITIAL.
        gv_fatal = 'XML_SELFTEST did not detect blank-value corruption'.
        RETURN.
      ENDIF.
    CATCH cx_root INTO lo_error.
      gv_fatal = lo_error->get_text( ).
  ENDTRY.
ENDFORM.

FORM add_text USING pv_relative TYPE csequence
                    pv_component TYPE csequence
                    pv_text TYPE string.
  DATA: lv_data TYPE xstring.
  PERFORM utf8 USING pv_text CHANGING lv_data.
  PERFORM add_file USING pv_relative pv_component lv_data.
ENDFORM.

FORM program_file USING pv_prog TYPE ty_name pv_pkg TYPE c
                  CHANGING cv_ok TYPE c cv_excluded TYPE c
                           ct_source TYPE ty_lines.
  DATA: lt_source TYPE ty_lines,
        lt_again TYPE ty_lines,
        lt_text TYPE STANDARD TABLE OF textpool,
        lv_line TYPE string,
        lv_text TYPE string,
        lv_segment TYPE string,
        lv_rel TYPE string,
        lv_component TYPE string,
        lv_xml TYPE xstring,
        lv_lang TYPE sy-langu,
        lv_iso TYPE c LENGTH 2,
        lv_rc TYPE sy-subrc,
        lr_attr TYPE REF TO data,
        lv_tab TYPE c LENGTH 30,
        lv_where TYPE string,
        lv_prog TYPE ty_name,
        lv_auth TYPE c LENGTH 1.
  FIELD-SYMBOLS: <ls_attr> TYPE ANY,
                 <lv_attr> TYPE ANY.
  CLEAR: cv_ok, cv_excluded.
  REFRESH ct_source.
  gv_stage = 'READ_REPORT'.
  gv_component = pv_prog.
  IF gs_object-object = 'FUGR'.
* Directory-verified main or API/TADIR-verified owned include only.
    PERFORM check_auth USING 'FUGR' gs_object-obj_name pv_pkg
      CHANGING lv_auth.
  ELSE.
    PERFORM check_auth USING 'PROG' pv_prog pv_pkg CHANGING lv_auth.
  ENDIF.
  IF lv_auth IS INITIAL.
    gv_error = 'Include/program display authorization denied'.
    PERFORM log USING 'READ_REPORT' 'FAILED' gv_error.
    RETURN.
  ENDIF.
  READ REPORT pv_prog INTO lt_source STATE 'A'.
  IF sy-subrc <> 0.
* Policy: no readable active source -> no payload and no processing log.
* This does not prove why READ REPORT failed. Do not label it inactive.
    cv_excluded = 'X'.
    RETURN.
  ENDIF.
  READ REPORT pv_prog INTO lt_again STATE 'A'.
  IF sy-subrc <> 0 OR lt_source <> lt_again.
    gv_error = 'Source changed between two reads; file skipped'.
    PERFORM log USING 'READ_REPORT' 'FAILED' gv_error.
    RETURN.
  ENDIF.
* String source lines are joined without trimming/condensing. Always LF
* after each repository line; no timestamps or pretty printing.
  LOOP AT lt_source INTO lv_line.
    CONCATENATE lv_text lv_line gv_lf INTO lv_text
      RESPECTING BLANKS.
  ENDLOOP.
  PERFORM segment USING pv_prog CHANGING lv_segment.
  IF gs_object-object = 'FUGR'.
    CONCATENATE 'Include/' lv_segment '.abap' INTO lv_rel.
  ELSE.
    CONCATENATE 'source/' lv_segment '.abap' INTO lv_rel.
  ENDIF.
  lv_component = pv_prog.
  CLEAR gv_file_language.
  PERFORM add_text USING lv_rel lv_component lv_text.

  gv_stage = 'READ_TEXTPOOL'.
  DO 1 TIMES.
    PERFORM korean_language CHANGING lv_lang lv_iso.
    REFRESH lt_text.
    READ TEXTPOOL pv_prog INTO lt_text LANGUAGE lv_lang STATE 'A'.
    lv_rc = sy-subrc.
    IF lv_rc <> 0 AND lv_rc <> 4.
      gv_error = 'Text pool read failed'.
      PERFORM log USING 'READ_TEXTPOOL' 'FAILED' gv_error.
      RETURN.
    ENDIF.
    IF lt_text IS INITIAL AND gv_language_en IS NOT INITIAL.
      lv_lang = gv_language_en. lv_iso = 'EN'.
      READ TEXTPOOL pv_prog INTO lt_text LANGUAGE lv_lang STATE 'A'.
      lv_rc = sy-subrc.
      IF lv_rc <> 0 AND lv_rc <> 4.
        gv_error = 'English fallback text pool read failed'.
        PERFORM log USING 'READ_TEXTPOOL' 'FAILED' gv_error. RETURN.
      ENDIF.
      IF lt_text IS NOT INITIAL.
        PERFORM log USING 'LANGUAGE_FALLBACK' 'INFO'
          'Korean text pool absent; English text pool selected'.
      ELSE.
* No available translation: retain empty KO result, not a fake EN success.
        PERFORM korean_language CHANGING lv_lang lv_iso. lv_rc = 4.
      ENDIF.
    ENDIF.
    CALL TRANSFORMATION id SOURCE language = lv_lang
      iso_language = lv_iso
      read_subrc = lv_rc entries = lt_text RESULT XML lv_xml.
    CONCATENATE 'texts/' lv_segment '.xml' INTO lv_rel.
    gv_file_language = lv_lang.
    PERFORM add_file USING lv_rel 'TEXTPOOL' lv_xml.
  ENDDO.
  CLEAR gv_file_language.
  gv_stage = 'ATTRIBUTES'.
* Runtime-resolved TRDIR type: no unverified static field references.
  lv_tab = 'TRDIR'.
  CREATE DATA lr_attr TYPE (lv_tab).
  ASSIGN lr_attr->* TO <ls_attr>.
  ASSIGN COMPONENT 'NAME' OF STRUCTURE <ls_attr> TO <lv_attr>.
  IF sy-subrc <> 0.
    gv_error = 'TRDIR NAME field unavailable'.
    PERFORM log USING 'ATTRIBUTES' 'FAILED' gv_error.
    RETURN.
  ENDIF.
  lv_prog = pv_prog.
  lv_where = 'NAME = LV_PROG'.
  SELECT SINGLE * FROM (lv_tab) INTO <ls_attr> WHERE (lv_where).
  IF sy-subrc <> 0.
    gv_error = 'TRDIR entry not found'.
    PERFORM log USING 'ATTRIBUTES' 'FAILED' gv_error.
    RETURN.
  ENDIF.
  CALL TRANSFORMATION id SOURCE attributes = <ls_attr>
    RESULT XML lv_xml.
  CONCATENATE 'attributes/' lv_segment '.xml' INTO lv_rel.
  PERFORM add_file USING lv_rel 'TRDIR_CATALOG' lv_xml.
  ct_source = lt_source.
  cv_ok = 'X'.
ENDFORM.

FORM export_program.
  DATA: lt_source TYPE ty_lines,
        lv_prog TYPE ty_name,
        lv_excluded TYPE c LENGTH 1,
        lv_ok TYPE c LENGTH 1.
  IF strlen( gs_object-obj_name ) > 40.
    gs_object-status = 'FAILED'.
    gs_object-reason = 'Program name exceeds runtime name length'.
    RETURN.
  ENDIF.
  lv_prog = gs_object-obj_name.
  PERFORM program_file USING lv_prog gs_object-devclass
    CHANGING lv_ok lv_excluded lt_source.
  IF lv_excluded = 'X'.
    gs_object-status = 'EXCLUDED'.
    gs_object-reason = 'No readable active source; excluded by policy'.
    RETURN.
  ENDIF.
  IF lv_ok IS INITIAL.
    gs_object-status = 'FAILED'.
    gs_object-reason = 'Program component read failed; inspect log'.
    RETURN.
  ENDIF.
  PERFORM scan_program USING lv_prog lt_source.
ENDFORM.

FORM scan_program USING pv_prog TYPE ty_name pt_source TYPE ty_lines.
* Analyze the same body that passed the two active reads and was saved.
* Recurse only through a verified same-owner FUGR queue, never by prefix.
  DATA: lt_includes TYPE ty_includes,
        lt_gaps TYPE ty_scan_gaps,
        ls_gap TYPE ty_scan_gap,
        ls_include TYPE ty_include,
        ls_ref TYPE ty_ref,
        ls_found TYPE ty_object,
        ls_owner TYPE ty_owner,
        lv_package_selected TYPE c,
        lv_root_selected TYPE c,
        lv_same_root TYPE c,
        lv_main_verified TYPE c,
        lv_macro TYPE c,
        lv_ok TYPE c LENGTH 1,
        lv_line_text TYPE c LENGTH 12,
        lv_detail TYPE string,
        lv_segment TYPE string,
        lv_path TYPE string,
        lv_xml TYPE xstring.
  INSERT pv_prog INTO TABLE gt_scanned.
  IF sy-subrc <> 0. RETURN. ENDIF.
  gv_stage = 'INCLUDE_SCAN'.
  gv_component = pv_prog.
  PERFORM read_direct_includes USING pt_source
    CHANGING lt_includes lt_gaps lv_ok.
  IF lv_ok IS INITIAL.
    LOOP AT lt_gaps INTO ls_gap.
      WRITE ls_gap-source_line TO lv_line_text.
      CONDENSE lv_line_text.
      CONCATENATE 'REASON=' ls_gap-reason '; LINE=' lv_line_text
        '; TOKEN=' ls_gap-target_token INTO lv_detail.
      PERFORM log USING 'INCLUDE_SCAN' 'UNRESOLVED' lv_detail.
    ENDLOOP.
    CALL TRANSFORMATION id SOURCE program = pv_prog gaps = lt_gaps
      RESULT XML lv_xml.
    PERFORM segment USING pv_prog CHANGING lv_segment.
    CONCATENATE 'include-diagnostics/' lv_segment '.xml' INTO lv_path.
    CLEAR gv_file_language.
    gv_payload_state = 'U'.
    PERFORM add_file USING lv_path 'INCLUDE_SCAN_DIAGNOSTIC' lv_xml.
    CLEAR gv_payload_state.
  ENDIF.
  LOOP AT lt_includes INTO ls_include.
    CLEAR ls_ref.
    ls_ref-source_program = pv_prog.
    ls_ref-target_program = ls_include-name.
    ls_ref-source_line = ls_include-source_line.
    ls_ref-optional = ls_include-optional.
    ls_ref-evidence = ls_include-evidence.
    ls_ref-relation = 'DIRECT_INCLUDE'.
    PERFORM resolve_include_owner USING ls_include-name
      CHANGING ls_owner.
    ls_ref-target_package = ls_owner-devclass.
    ls_ref-owner_object = ls_owner-object.
    ls_ref-owner_name = ls_owner-obj_name.
    ls_ref-owner_evidence = ls_owner-evidence.
    ls_ref-owner_detail = ls_owner-detail.
    CLEAR: lv_package_selected, lv_root_selected, lv_same_root,
           lv_main_verified, lv_macro.
    READ TABLE gt_seen_pkg WITH TABLE KEY devclass = ls_owner-devclass
      TRANSPORTING NO FIELDS.
    IF sy-subrc = 0. lv_package_selected = 'X'. ENDIF.
    READ TABLE gt_objects INTO ls_found WITH KEY pgmid = 'R3TR'
      object = ls_owner-object obj_name = ls_owner-obj_name.
    IF sy-subrc = 0. lv_root_selected = 'X'. ENDIF.
    IF gs_object-object = 'FUGR' AND ls_owner-object = 'FUGR' AND
       gs_object-obj_name = ls_owner-obj_name AND
       gs_object-devclass = ls_owner-devclass.
      lv_same_root = 'X'.
      READ TABLE gt_fugr_mains WITH TABLE KEY
        table_line = ls_owner-main_program TRANSPORTING NO FIELDS.
      IF sy-subrc = 0. lv_main_verified = 'X'. ENDIF.
    ENDIF.
    IF ls_include-evidence = 'MACRO_CANDIDATE'. lv_macro = 'X'. ENDIF.
    PERFORM include_scope USING ls_owner lv_package_selected
      lv_root_selected lv_same_root lv_main_verified lv_macro
      CHANGING ls_ref-scope.
    IF ls_ref-scope = 'IN_SCOPE_COMPONENT'.
      PERFORM queue_include USING ls_owner pv_prog.
    ELSEIF ls_ref-scope = 'OWNER_UNRESOLVED'.
      IF ls_owner-verified = 'X'.
        ls_ref-owner_detail = 'Owner main differs from verified directory'.
      ENDIF.
      gv_component = ls_include-name.
      PERFORM log USING 'INCLUDE_OWNER' 'UNRESOLVED'
        ls_ref-owner_detail.
    ENDIF.
    APPEND ls_ref TO gt_refs.
  ENDLOOP.
ENDFORM.

FORM prepare_include_owner.
* Check the active local interface before any dynamic call.
  DATA: lt_specs TYPE ty_lines,
        lv_spec TYPE string,
        lv_parameter TYPE fupararef-parameter,
        lv_direction TYPE fupararef-paramtype,
        lv_structure TYPE fupararef-structure,
        ls_meta TYPE fupararef,
        lv_count TYPE i,
        lo_error TYPE REF TO cx_root.
  IF gv_owner_prepared = 'X'. RETURN. ENDIF.
  gv_owner_prepared = 'X'.
  gv_owner_reason = 'Active include owner API interface not verified'.
  TRY.
      SELECT * FROM fupararef INTO TABLE gt_owner_api_meta
        WHERE funcname = 'FUNCTION_INCLUDE_SPLIT' AND r3state = 'A'.
      SORT gt_owner_api_meta BY parameter paramtype.
      APPEND 'INCLUDE|C|RS38L-INCLUDE' TO lt_specs.
      APPEND 'GROUP|E|RS38L-AREA' TO lt_specs.
      APPEND 'NAMESPACE|E|RS38L-NAMESPACE' TO lt_specs.
      LOOP AT lt_specs INTO lv_spec.
        SPLIT lv_spec AT '|' INTO lv_parameter lv_direction lv_structure.
        CLEAR: lv_count, ls_meta.
        LOOP AT gt_owner_api_meta INTO ls_meta
          WHERE parameter = lv_parameter AND paramtype = lv_direction.
          ADD 1 TO lv_count.
        ENDLOOP.
        IF lv_count <> 1 OR ls_meta-structure <> lv_structure OR
           ls_meta-ref_class IS NOT INITIAL OR
           ls_meta-line_of IS NOT INITIAL OR
           ls_meta-table_of IS NOT INITIAL.
          CONCATENATE 'Owner API interface differs at' lv_parameter
            INTO gv_owner_reason SEPARATED BY space.
          RETURN.
        ENDIF.
      ENDLOOP.
      LOOP AT gt_owner_api_meta INTO ls_meta.
        IF ls_meta-paramtype <> 'I' AND ls_meta-paramtype <> 'C' AND
           ls_meta-paramtype <> 'T'. CONTINUE. ENDIF.
        IF ls_meta-parameter = 'INCLUDE' AND ls_meta-paramtype = 'C'.
          CONTINUE.
        ENDIF.
        IF ls_meta-optional IS INITIAL AND ls_meta-defaultval IS INITIAL.
          CONCATENATE 'Owner API requires additional input'
            ls_meta-parameter INTO gv_owner_reason SEPARATED BY space.
          RETURN.
        ENDIF.
      ENDLOOP.
      gv_owner_ready = 'X'.
      gv_owner_reason = 'Active interface verified; API + TADIR required'.
    CATCH cx_root INTO lo_error.
      gv_owner_reason = lo_error->get_text( ).
  ENDTRY.
ENDFORM.

FORM resolve_include_owner USING pv_prog TYPE ty_name
                           CHANGING cs_owner TYPE ty_owner.
  DATA: lv_include TYPE rs38l-include,
        lv_group TYPE rs38l-area,
        lv_namespace TYPE rs38l-namespace,
        lv_name TYPE string,
        lv_api TYPE c LENGTH 30,
        lv_rc TYPE sy-subrc,
        lv_rc_text TYPE c LENGTH 12,
        lo_error TYPE REF TO cx_root.
  CLEAR cs_owner.
  READ TABLE gt_owners INTO cs_owner WITH TABLE KEY program = pv_prog.
  IF sy-subrc = 0. RETURN. ENDIF.
  cs_owner-program = pv_prog.
* A separately registered program always takes precedence over FUGR.
  SELECT SINGLE devclass FROM tadir INTO cs_owner-devclass
    WHERE pgmid = 'R3TR' AND object = 'PROG' AND obj_name = pv_prog.
  IF sy-subrc = 0.
    cs_owner-object = 'PROG'.
    cs_owner-obj_name = pv_prog.
    cs_owner-evidence = 'TADIR_PROG'.
    cs_owner-verified = 'X'.
    cs_owner-detail = 'Exact R3TR PROG registration'.
  ELSE.
    PERFORM prepare_include_owner.
    cs_owner-detail = gv_owner_reason.
    IF gv_owner_ready = 'X'.
      TRY.
          lv_include = pv_prog.
          IF lv_include <> pv_prog.
            cs_owner-detail = 'Name exceeds include API field length'.
          ELSE.
            lv_api = 'FUNCTION_INCLUDE_SPLIT'.
            CALL FUNCTION lv_api
              IMPORTING namespace = lv_namespace group = lv_group
              CHANGING include = lv_include
              EXCEPTIONS error_message = 1 OTHERS = 2.
            lv_rc = sy-subrc.
            IF lv_rc <> 0 OR lv_group IS INITIAL OR lv_include <> pv_prog.
              WRITE lv_rc TO lv_rc_text. CONDENSE lv_rc_text.
              CONCATENATE 'Owner API rejected/unresolved name; SUBRC='
                lv_rc_text '; MSG=' sy-msgid '/' sy-msgno
                INTO cs_owner-detail.
            ELSE.
              CONCATENATE lv_namespace lv_group INTO lv_name.
              cs_owner-object = 'FUGR'.
              IF lv_group+0(1) = 'X'. cs_owner-object = 'FUGS'. ENDIF.
              cs_owner-obj_name = lv_name.
              IF cs_owner-obj_name <> lv_name.
                cs_owner-detail = 'Owner name exceeds TADIR field length'.
              ELSE.
                SELECT SINGLE devclass FROM tadir INTO cs_owner-devclass
                  WHERE pgmid = 'R3TR' AND object = cs_owner-object
                    AND obj_name = cs_owner-obj_name.
                IF sy-subrc <> 0.
                  cs_owner-detail = 'API owner has no exact TADIR entry'.
                ELSE.
                  CONCATENATE lv_namespace 'SAPL' lv_group INTO lv_name.
                  cs_owner-main_program = lv_name.
                  IF cs_owner-main_program <> lv_name.
                    cs_owner-detail = 'Owner main name exceeds 40 chars'.
                  ELSE.
                    cs_owner-verified = 'X'.
                    cs_owner-evidence = 'SPLIT_API_TADIR'.
                    cs_owner-detail = 'FUNCTION_INCLUDE_SPLIT + TADIR'.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        CATCH cx_root INTO lo_error.
          CLEAR cs_owner-verified.
          cs_owner-detail = lo_error->get_text( ).
      ENDTRY.
    ENDIF.
  ENDIF.
  INSERT cs_owner INTO TABLE gt_owners.
ENDFORM.

FORM include_scope USING ps_owner TYPE ty_owner
                         pv_package_selected TYPE c
                         pv_root_selected TYPE c
                         pv_same_root TYPE c
                         pv_main_verified TYPE c
                         pv_macro TYPE c
                   CHANGING cv_scope TYPE c.
* Scope is a policy decision, not evidence that a file was exported.
  cv_scope = 'OWNER_UNRESOLVED'.
  IF pv_macro = 'X'.
    cv_scope = 'MACRO_REFERENCE_ONLY'.
  ELSEIF ps_owner-verified <> 'X'.
    RETURN.
  ELSEIF pv_package_selected <> 'X'.
    cv_scope = 'EXTERNAL_REFERENCE_ONLY'.
  ELSEIF pv_root_selected <> 'X'.
    cv_scope = 'FILTERED_REFERENCE_ONLY'.
  ELSEIF ps_owner-object = 'PROG'.
    cv_scope = 'IN_SCOPE_ROOT'.
  ELSEIF ps_owner-object = 'FUGR'.
    IF pv_same_root = 'X'.
      IF pv_main_verified = 'X'. cv_scope = 'IN_SCOPE_COMPONENT'. ENDIF.
    ELSE.
      cv_scope = 'OTHER_ROOT_REFERENCE'.
    ENDIF.
  ELSE.
    cv_scope = 'UNSUPPORTED_OWNER'.
  ENDIF.
ENDFORM.

FORM test_include_scope.
  DATA: ls_owner TYPE ty_owner,
        lv_scope TYPE c LENGTH 24,
        lt_cases TYPE ty_lines,
        lv_case TYPE string,
        lv_verified TYPE c,
        lv_object TYPE c LENGTH 4,
        lv_package TYPE c,
        lv_root TYPE c,
        lv_same TYPE c,
        lv_main TYPE c,
        lv_macro TYPE c,
        lv_expected TYPE c LENGTH 24.
  APPEND 'X|FUGR|X|X|X|X||IN_SCOPE_COMPONENT' TO lt_cases.
  APPEND 'X|FUGR||X|X|X||EXTERNAL_REFERENCE_ONLY' TO lt_cases.
  APPEND 'X|FUGR|X||X|X||FILTERED_REFERENCE_ONLY' TO lt_cases.
  APPEND 'X|FUGR|X|X||X||OTHER_ROOT_REFERENCE' TO lt_cases.
  APPEND 'X|FUGR|X|X|X|||OWNER_UNRESOLVED' TO lt_cases.
  APPEND '|FUGR|X|X|X|X||OWNER_UNRESOLVED' TO lt_cases.
  APPEND 'X|PROG|X|X|X|X||IN_SCOPE_ROOT' TO lt_cases.
  APPEND 'X|FUGS|X|X|X|X||UNSUPPORTED_OWNER' TO lt_cases.
  APPEND 'X|FUGR|X|X|X|X|X|MACRO_REFERENCE_ONLY' TO lt_cases.
  LOOP AT lt_cases INTO lv_case.
    SPLIT lv_case AT '|' INTO lv_verified lv_object lv_package
      lv_root lv_same lv_main lv_macro lv_expected.
    CLEAR ls_owner.
    ls_owner-verified = lv_verified.
    ls_owner-object = lv_object.
    lv_scope = 'PREVIOUS_CALL'.
    PERFORM include_scope USING ls_owner lv_package lv_root
      lv_same lv_main lv_macro CHANGING lv_scope.
    IF lv_scope <> lv_expected.
      gv_fatal = 'Include scope policy self-test failed'. RETURN.
    ENDIF.
  ENDLOOP.
ENDFORM.

FORM queue_include USING ps_owner TYPE ty_owner pv_source TYPE ty_name.
  DATA: ls_item TYPE ty_owned_include,
        lv_count TYPE i.
  READ TABLE gt_queued WITH TABLE KEY table_line = ps_owner-program
    TRANSPORTING NO FIELDS.
  IF sy-subrc = 0. RETURN. ENDIF.
  DESCRIBE TABLE gt_include_queue LINES lv_count.
  IF lv_count >= 5000.
    gs_object-status = 'FAILED'.
    gs_object-reason = 'Internal include queue exceeds 5000 per group'.
    PERFORM log USING 'FUGR_INCLUDE' 'FAILED' gs_object-reason.
    RETURN.
  ENDIF.
  INSERT ps_owner-program INTO TABLE gt_queued.
  ls_item-program = ps_owner-program.
  ls_item-source_program = pv_source.
  ls_item-owner_object = ps_owner-object.
  ls_item-owner_name = ps_owner-obj_name.
  ls_item-owner_package = ps_owner-devclass.
  ls_item-owner_evidence = ps_owner-evidence.
  ls_item-status = 'QUEUED'.
  APPEND ls_item TO gt_include_queue.
ENDFORM.

FORM check_include_entry USING pv_prog TYPE ty_name
                         CHANGING cv_ok TYPE c cv_detail TYPE string.
* Metadata check precedes READ REPORT. Never read a foreign body here.
  DATA: lr_row TYPE REF TO data,
        lv_table TYPE c LENGTH 30,
        lv_where TYPE string,
        lv_prog TYPE ty_name.
  FIELD-SYMBOLS: <ls_row> TYPE ANY, <lv_value> TYPE ANY.
  CLEAR: cv_ok, cv_detail.
  lv_table = 'TRDIR'.
  CREATE DATA lr_row TYPE (lv_table).
  ASSIGN lr_row->* TO <ls_row>.
  lv_prog = pv_prog.
  lv_where = 'NAME = LV_PROG'.
  SELECT SINGLE * FROM (lv_table) INTO <ls_row> WHERE (lv_where).
  IF sy-subrc <> 0.
    cv_detail = 'TRDIR include entry absent'. RETURN.
  ENDIF.
  ASSIGN COMPONENT 'SUBC' OF STRUCTURE <ls_row> TO <lv_value>.
  IF sy-subrc <> 0.
    cv_detail = 'TRDIR SUBC unavailable'. RETURN.
  ENDIF.
  IF <lv_value> <> 'I'.
    cv_detail = 'TRDIR entry is not an include (SUBC I required)'. RETURN.
  ENDIF.
  cv_ok = 'X'.
ENDFORM.

FORM export_owned_includes.
  DATA: ls_item TYPE ty_owned_include,
        lt_source TYPE ty_lines,
        lv_pos TYPE i,
        lv_ok TYPE c,
        lv_excluded TYPE c,
        lv_complete TYPE i,
        lv_failed TYPE i,
        lv_complete_text TYPE c LENGTH 12,
        lv_failed_text TYPE c LENGTH 12,
        lv_xml TYPE xstring,
        lv_detail TYPE string,
        lo_error TYPE REF TO cx_root.
  lv_pos = 1.
  DO.
    READ TABLE gt_include_queue INTO ls_item INDEX lv_pos.
    IF sy-subrc <> 0. EXIT. ENDIF.
    gv_component = ls_item-program.
    CLEAR: gv_payload_state, gv_file_language, lv_ok, lv_detail,
           lv_excluded.
    TRY.
        PERFORM check_include_entry USING ls_item-program
          CHANGING lv_ok lv_detail.
        IF lv_ok = 'X'.
          PERFORM program_file USING ls_item-program gs_object-devclass
            CHANGING lv_ok lv_excluded lt_source.
          IF lv_ok = 'X'.
            PERFORM scan_program USING ls_item-program lt_source.
          ELSE.
            lv_detail = 'Include component read failed; inspect log'.
          ENDIF.
        ENDIF.
      CATCH cx_root INTO lo_error.
        CLEAR lv_ok.
        lv_detail = lo_error->get_text( ).
    ENDTRY.
    IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
    IF lv_ok = 'X'.
      ls_item-status = 'EXPORTED'.
      ls_item-detail = 'Active body/text; TRDIR metadata version U'.
      ADD 1 TO lv_complete.
    ELSEIF lv_excluded = 'X'.
      ls_item-status = 'EXCLUDED'.
      ls_item-detail = 'No readable active source; excluded by policy'.
    ELSE.
      ls_item-status = 'FAILED'.
      ls_item-detail = lv_detail.
      ADD 1 TO lv_failed.
      gv_component = ls_item-program.
      PERFORM log USING 'FUGR_INCLUDE' 'FAILED' lv_detail.
    ENDIF.
    MODIFY gt_include_queue FROM ls_item INDEX lv_pos.
    ADD 1 TO lv_pos.
  ENDDO.
  CLEAR gv_file_language.
  gv_payload_state = 'U'.
  CALL TRANSFORMATION id SOURCE includes = gt_include_queue
    RESULT XML lv_xml.
  PERFORM add_file USING 'Include/includes.xml' 'INCLUDE_COMPONENT_CATALOG' lv_xml.
  CLEAR gv_payload_state.
  WRITE lv_complete TO lv_complete_text. CONDENSE lv_complete_text.
  WRITE lv_failed TO lv_failed_text. CONDENSE lv_failed_text.
  CONCATENATE 'Owned includes completed=' lv_complete_text
    '; failed=' lv_failed_text '; scope=verified same FUGR only'
    INTO lv_detail.
  gv_component = gs_object-obj_name.
  PERFORM log USING 'FUGR_INCLUDE_SUMMARY' 'INFO' lv_detail.
  IF lv_failed > 0.
    gs_object-status = 'FAILED'.
    gs_object-reason = 'One or more owned include components failed'.
  ENDIF.
ENDFORM.

FORM read_direct_includes USING pt_source TYPE ty_lines
                         CHANGING ct_refs TYPE ty_includes
                                  ct_gaps TYPE ty_scan_gaps
                                  cv_ok TYPE c.
* Bounded lexical reader, not a full parser or syntax validator.
* Normalize only a temporary statement, never the exported source.
  DATA: lv_line TYPE string,
        lv_statement TYPE string,
        lv_char TYPE c LENGTH 1,
        lv_next TYPE c LENGTH 1,
        lv_quote TYPE c LENGTH 1,
        lv_pos TYPE i,
        lv_length TYPE i,
        lv_row TYPE i,
        lv_start TYPE i,
        lv_macro TYPE c LENGTH 1,
        lv_sql TYPE c LENGTH 1.
  REFRESH: ct_refs, ct_gaps.
  cv_ok = 'X'.
  LOOP AT pt_source INTO lv_line.
    lv_row = sy-tabix.
    lv_length = strlen( lv_line ).
    IF lv_length = 0. CONTINUE. ENDIF.
    IF lv_line+0(1) = '*' AND lv_quote IS INITIAL. CONTINUE. ENDIF.
    lv_pos = 0.
    WHILE lv_pos < lv_length.
      lv_char = lv_line+lv_pos(1).
      ADD 1 TO lv_pos.
      IF lv_quote IS NOT INITIAL.
        IF lv_char = lv_quote.
          CLEAR lv_next.
          IF lv_pos < lv_length. lv_next = lv_line+lv_pos(1). ENDIF.
          IF lv_next = lv_quote.
            ADD 1 TO lv_pos.
          ELSE.
            CLEAR lv_quote.
          ENDIF.
        ENDIF.
        CONTINUE.
      ENDIF.
      IF lv_char = '"'. EXIT. ENDIF.
      IF lv_char = space OR lv_char = gv_tab.
        CONCATENATE lv_statement ' ' INTO lv_statement
          RESPECTING BLANKS.
        CONTINUE.
      ENDIF.
      IF lv_start = 0. lv_start = lv_row. ENDIF.
      IF lv_char = '''' OR lv_char = '`'.
        lv_quote = lv_char.
        CONCATENATE lv_statement '#' INTO lv_statement.
      ELSEIF lv_char = '.'.
        PERFORM include_statement USING lv_statement lv_start
          CHANGING ct_refs ct_gaps lv_macro lv_sql cv_ok.
        CLEAR: lv_statement, lv_start.
      ELSEIF lv_char = ':' OR lv_char = ','.
        CONCATENATE lv_statement ' ' lv_char ' ' INTO lv_statement
          RESPECTING BLANKS.
      ELSE.
        CONCATENATE lv_statement lv_char INTO lv_statement
          RESPECTING BLANKS.
      ENDIF.
    ENDWHILE.
    CONCATENATE lv_statement ' ' INTO lv_statement RESPECTING BLANKS.
  ENDLOOP.
  CONDENSE lv_statement.
  IF lv_quote IS NOT INITIAL.
    PERFORM include_gap USING lv_start 'UNTERMINATED_QUOTED_LITERAL'
      CHANGING ct_gaps cv_ok.
  ELSEIF lv_statement IS NOT INITIAL.
    PERFORM include_gap USING lv_start 'UNTERMINATED_STATEMENT'
      CHANGING ct_gaps cv_ok.
  ENDIF.
  IF lv_macro IS NOT INITIAL.
    PERFORM include_gap USING lv_row 'OPEN_MACRO_AT_END_OF_SOURCE'
      CHANGING ct_gaps cv_ok.
  ENDIF.
  IF lv_sql IS NOT INITIAL.
    PERFORM include_gap USING lv_row 'OPEN_NATIVE_SQL_AT_END_OF_SOURCE'
      CHANGING ct_gaps cv_ok.
  ENDIF.
ENDFORM.

FORM include_gap USING pv_row TYPE i pv_reason TYPE c
                 CHANGING ct_gaps TYPE ty_scan_gaps cv_ok TYPE c.
  DATA ls_gap TYPE ty_scan_gap.
  ls_gap-source_line = pv_row.
  ls_gap-reason = pv_reason.
  APPEND ls_gap TO ct_gaps.
  CLEAR cv_ok.
ENDFORM.

FORM include_statement USING pv_statement TYPE string pv_row TYPE i
                       CHANGING ct_refs TYPE ty_includes
                                ct_gaps TYPE ty_scan_gaps
                                cv_macro TYPE c cv_sql TYPE c
                                cv_ok TYPE c.
  DATA: lv_statement TYPE string,
        lt_tokens TYPE ty_lines,
        lv_token TYPE string,
        lv_first TYPE string,
        lv_second TYPE string,
        lv_third TYPE string,
        lv_i TYPE i,
        lv_n TYPE i,
        lv_name_ok TYPE c LENGTH 1,
        ls_gap TYPE ty_scan_gap,
        lv_chain TYPE c LENGTH 1,
        ls_ref TYPE ty_include.
  lv_statement = pv_statement.
  TRANSLATE lv_statement TO UPPER CASE.
  CONDENSE lv_statement.
  IF lv_statement IS INITIAL. RETURN. ENDIF.
  SPLIT lv_statement AT space INTO TABLE lt_tokens.
  READ TABLE lt_tokens INTO lv_first INDEX 1.
  READ TABLE lt_tokens INTO lv_second INDEX 2.
  IF cv_sql = 'X'.
    LOOP AT lt_tokens INTO lv_token.
      IF lv_token = 'ENDEXEC'. CLEAR cv_sql. ENDIF.
    ENDLOOP.
    RETURN.
  ENDIF.
  IF lv_first = 'EXEC' AND lv_second = 'SQL'.
    cv_sql = 'X'. RETURN.
  ENDIF.
  IF lv_first = 'DEFINE'. cv_macro = 'X'. RETURN. ENDIF.
  IF lv_first = 'END-OF-DEFINITION'. CLEAR cv_macro. RETURN. ENDIF.
  IF lv_first <> 'INCLUDE'. RETURN. ENDIF.
  lv_i = 2.
  IF lv_second = ':'. lv_chain = 'X'. lv_i = 3. ENDIF.
  READ TABLE lt_tokens INTO lv_token INDEX lv_i.
  IF lv_token = 'TYPE' OR lv_token = 'STRUCTURE'. RETURN. ENDIF.
  DESCRIBE TABLE lt_tokens LINES lv_n.
  IF lv_i > lv_n.
    PERFORM include_gap USING pv_row 'INCLUDE_WITHOUT_NAME'
      CHANGING ct_gaps cv_ok. RETURN.
  ENDIF.
  WHILE lv_i <= lv_n.
    CLEAR ls_ref.
    READ TABLE lt_tokens INTO lv_token INDEX lv_i.
    PERFORM static_include_name USING lv_token CHANGING lv_name_ok.
    IF lv_name_ok IS INITIAL.
      CLEAR ls_gap.
      ls_gap-source_line = pv_row.
      ls_gap-reason = 'UNSUPPORTED_INCLUDE_TARGET'.
      ls_gap-target_token = lv_token.
      APPEND ls_gap TO ct_gaps.
      CLEAR cv_ok. RETURN.
    ENDIF.
    ls_ref-name = lv_token.
    ls_ref-source_line = pv_row.
    ls_ref-evidence = 'STATIC_STATEMENT'.
    IF cv_macro = 'X'. ls_ref-evidence = 'MACRO_CANDIDATE'. ENDIF.
    ADD 1 TO lv_i.
    IF lv_i <= lv_n.
      READ TABLE lt_tokens INTO lv_token INDEX lv_i.
      IF lv_token = 'IF'.
        ADD 1 TO lv_i.
        CLEAR lv_third.
        READ TABLE lt_tokens INTO lv_third INDEX lv_i.
        IF lv_third <> 'FOUND'.
          PERFORM include_gap USING pv_row 'UNSUPPORTED_INCLUDE_ADDITION'
            CHANGING ct_gaps cv_ok. RETURN.
        ENDIF.
        ls_ref-optional = 'X'.
        ADD 1 TO lv_i.
      ENDIF.
    ENDIF.
    IF lv_i <= lv_n.
      READ TABLE lt_tokens INTO lv_token INDEX lv_i.
      IF lv_token <> ',' OR lv_chain IS INITIAL.
        PERFORM include_gap USING pv_row 'UNSUPPORTED_INCLUDE_ADDITION'
          CHANGING ct_gaps cv_ok. RETURN.
      ENDIF.
    ENDIF.
    APPEND ls_ref TO ct_refs.
    IF lv_i <= lv_n.
      ADD 1 TO lv_i.
      IF lv_i > lv_n.
        PERFORM include_gap USING pv_row 'INCLUDE_TRAILING_COMMA'
          CHANGING ct_gaps cv_ok. RETURN.
      ENDIF.
    ENDIF.
  ENDWHILE.
ENDFORM.

FORM static_include_name USING pv_name TYPE string
                         CHANGING cv_ok TYPE c.
  DATA: lv_name TYPE string,
        lv_len TYPE i,
        lv_last TYPE i.
  CLEAR cv_ok.
  lv_name = pv_name.
  lv_len = strlen( lv_name ).
  IF lv_len = 0 OR lv_len > 40. RETURN. ENDIF.
* Standard angle-bracket includes, for example <ICON> and <SYMBOL>.
* Accept only one balanced outer pair; never dynamic (name) syntax.
  IF lv_name+0(1) = '<'.
    IF lv_len < 3. RETURN. ENDIF.
    lv_last = lv_len - 1.
    IF lv_name+lv_last(1) <> '>'. RETURN. ENDIF.
    lv_len = lv_len - 2.
    lv_name = lv_name+1(lv_len).
  ENDIF.
  IF lv_name CN 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_/$%=-'.
    RETURN.
  ENDIF.
  cv_ok = 'X'.
ENDFORM.

FORM test_include_reader.
  DATA: lt_source TYPE ty_lines,
        lt_refs TYPE ty_includes,
        lt_gaps TYPE ty_scan_gaps,
        ls_gap TYPE ty_scan_gap,
        ls_ref TYPE ty_include,
        lv_line TYPE string,
        lv_ok TYPE c LENGTH 1,
        lv_count TYPE i.
  lv_line = '* INCLUDE ZFAKE1.'. APPEND lv_line TO lt_source.
  lv_line = 'WRITE ''INCLUDE ZFAKE2.''.'. APPEND lv_line TO lt_source.
  lv_line = 'WRITE `INCLUDE ZFAKE3.`.'. APPEND lv_line TO lt_source.
  lv_line = '" INCLUDE ZFAKE4.'. APPEND lv_line TO lt_source.
  lv_line = 'INCLUDE TYPE ZSTRUCT.'. APPEND lv_line TO lt_source.
  lv_line = 'INCLUDE STRUCTURE ZSTRUCT.'. APPEND lv_line TO lt_source.
  lv_line = 'INCLUDE ZONE. " comment'. APPEND lv_line TO lt_source.
  lv_line = 'include'. APPEND lv_line TO lt_source.
  lv_line = ' /NS/ZTWO IF FOUND.'. APPEND lv_line TO lt_source.
  lv_line = 'INCLUDE: ZTHREE, ZFOUR.'. APPEND lv_line TO lt_source.
  lv_line = 'DEFINE MAC.'. APPEND lv_line TO lt_source.
  lv_line = 'INCLUDE ZMAC.'. APPEND lv_line TO lt_source.
  lv_line = 'END-OF-DEFINITION.'. APPEND lv_line TO lt_source.
  lv_line = 'EXEC SQL.'. APPEND lv_line TO lt_source.
  lv_line = 'INCLUDE ZFAKE5.'. APPEND lv_line TO lt_source.
  lv_line = 'ENDEXEC.'. APPEND lv_line TO lt_source.
  lv_line = 'INCLUDE <ICON>.'. APPEND lv_line TO lt_source.
  lv_line = 'INCLUDE <SYMBOL> IF FOUND.'. APPEND lv_line TO lt_source.
  PERFORM read_direct_includes USING lt_source
    CHANGING lt_refs lt_gaps lv_ok.
  DESCRIBE TABLE lt_refs LINES lv_count.
  IF lv_ok IS INITIAL OR lv_count <> 7.
    gv_fatal = 'Direct INCLUDE reader self-test failed'. RETURN.
  ENDIF.
  READ TABLE lt_refs INTO ls_ref INDEX 1.
  IF ls_ref-name <> 'ZONE' OR ls_ref-source_line <> 7.
    gv_fatal = 'Direct INCLUDE reader line self-test failed'. RETURN.
  ENDIF.
  READ TABLE lt_refs INTO ls_ref INDEX 2.
  IF ls_ref-name <> '/NS/ZTWO' OR ls_ref-optional <> 'X' OR
     ls_ref-source_line <> 8.
    gv_fatal = 'Direct INCLUDE reader optional self-test failed'.
    RETURN.
  ENDIF.
  READ TABLE lt_refs INTO ls_ref INDEX 5.
  IF ls_ref-name <> 'ZMAC' OR ls_ref-evidence <> 'MACRO_CANDIDATE'.
    gv_fatal = 'Direct INCLUDE reader macro self-test failed'.
    RETURN.
  ENDIF.
  READ TABLE lt_refs INTO ls_ref INDEX 6.
  IF ls_ref-name <> '<ICON>' OR ls_ref-source_line <> 17.
    gv_fatal = 'Angle INCLUDE self-test failed'. RETURN.
  ENDIF.
  READ TABLE lt_refs INTO ls_ref INDEX 7.
  IF ls_ref-name <> '<SYMBOL>' OR ls_ref-optional <> 'X'.
    gv_fatal = 'Optional angle INCLUDE self-test failed'. RETURN.
  ENDIF.
  lv_line = '<BAD>>'.
  PERFORM static_include_name USING lv_line CHANGING lv_ok.
  IF lv_ok IS NOT INITIAL.
    gv_fatal = 'Malformed angle INCLUDE accepted'. RETURN.
  ENDIF.
  REFRESH lt_source.
  lv_line = 'INCLUDE (lv_name).'. APPEND lv_line TO lt_source.
  PERFORM read_direct_includes USING lt_source
    CHANGING lt_refs lt_gaps lv_ok.
  READ TABLE lt_gaps INTO ls_gap INDEX 1.
  IF lv_ok IS NOT INITIAL OR sy-subrc <> 0 OR
     ls_gap-source_line <> 1 OR
     ls_gap-reason <> 'UNSUPPORTED_INCLUDE_TARGET' OR
     ls_gap-target_token <> '(LV_NAME)'.
    gv_fatal = 'Direct INCLUDE gap self-test failed'.
  ENDIF.
ENDFORM.


FORM export_function_group.
  DATA: lt_source TYPE ty_lines,
        lr_dir TYPE REF TO data,
        lr_row TYPE REF TO data,
        lr_tfdir TYPE REF TO data,
        lt_functions TYPE ty_functions,
        ls_function TYPE ty_function,
        lt_mains TYPE SORTED TABLE OF ty_name
          WITH UNIQUE KEY table_line,
        lt_excluded_mains TYPE SORTED TABLE OF ty_name
          WITH UNIQUE KEY table_line,
        lv_excluded TYPE c LENGTH 1,
        lv_main TYPE ty_name,
        lv_table TYPE c LENGTH 30,
        lv_where TYPE string,
        lv_area TYPE rs38l-area,
        lv_function TYPE rs38l-name,
        lv_ok TYPE c LENGTH 1,
        lv_errors TYPE i,
        lv_function_ok TYPE i,
        lv_function_failed TYPE i,
        lv_source_count TYPE i,
        lv_new_count TYPE i,
        lv_source_text TYPE c LENGTH 12,
        lv_new_text TYPE c LENGTH 12,
        lv_container TYPE c LENGTH 10,
        lv_ok_text TYPE c LENGTH 12,
        lv_failed_text TYPE c LENGTH 12,
        lv_index TYPE i,
        lv_count TYPE i,
        lv_count_text TYPE c LENGTH 12,
        lv_xml TYPE xstring,
        lv_name TYPE string,
        lv_error TYPE string,
        lo_error TYPE REF TO cx_root.
  FIELD-SYMBOLS: <lt_dir> TYPE STANDARD TABLE,
                 <ls_dir> TYPE ANY,
                 <ls_tfdir> TYPE ANY,
                 <lv_value> TYPE ANY.
  REFRESH: gt_include_queue, gt_queued, gt_fugr_mains.
  PERFORM prepare_include_owner.
  gv_component = gs_object-obj_name.
  gv_payload_state = 'U'.
  CLEAR gv_file_language.
  PERFORM log USING 'INCLUDE_OWNER_API' 'INFO' gv_owner_reason.
  CLEAR gv_payload_state.
  PERFORM prepare_function_reader.
  gv_component = gs_object-obj_name.
  gv_payload_state = 'U'.
  CLEAR gv_file_language.
  CONCATENATE 'API=' gv_function_api '; ' gv_api_reason INTO lv_error.
  PERFORM log USING 'FUNCTION_API' 'INFO' lv_error.
  CLEAR gv_payload_state.
  gv_stage = 'FUGR_DIRECTORY'.
  gv_component = gs_object-obj_name.
  lv_area = gs_object-obj_name.
  IF lv_area <> gs_object-obj_name.
    gs_object-status = 'FAILED'.
    gs_object-reason = 'Function group name exceeds API field length'.
    PERFORM log USING gv_stage 'FAILED' gs_object-reason. RETURN.
  ENDIF.
  lv_table = 'ENLFDIR'.
  CREATE DATA lr_dir TYPE STANDARD TABLE OF (lv_table).
  CREATE DATA lr_row TYPE (lv_table).
  ASSIGN lr_dir->* TO <lt_dir>.
  ASSIGN lr_row->* TO <ls_dir>.
  ASSIGN COMPONENT 'AREA' OF STRUCTURE <ls_dir> TO <lv_value>.
  IF sy-subrc <> 0.
    gs_object-status = 'FAILED'.
    gs_object-reason = 'ENLFDIR AREA unavailable'.
    PERFORM log USING gv_stage 'FAILED' gs_object-reason. RETURN.
  ENDIF.
  ASSIGN COMPONENT 'FUNCNAME' OF STRUCTURE <ls_dir> TO <lv_value>.
  IF sy-subrc <> 0.
    gs_object-status = 'FAILED'.
    gs_object-reason = 'ENLFDIR FUNCNAME unavailable'.
    PERFORM log USING gv_stage 'FAILED' gs_object-reason. RETURN.
  ENDIF.
  lv_where = 'AREA = LV_AREA'.
  SELECT * FROM (lv_table) INTO TABLE <lt_dir> WHERE (lv_where).
  LOOP AT <lt_dir> ASSIGNING <ls_dir>.
    ASSIGN COMPONENT 'FUNCNAME' OF STRUCTURE <ls_dir> TO <lv_value>.
    lv_name = <lv_value>.
    IF strlen( lv_name ) > 30 OR lv_name IS INITIAL.
      ADD 1 TO lv_errors.
      PERFORM log USING gv_stage 'FAILED'
        'Directory function name empty or too long; skipped'.
      CONTINUE.
    ENDIF.
    CLEAR ls_function.
    ls_function-funcname = lv_name.
    ls_function-area = lv_area.
    APPEND ls_function TO lt_functions.
  ENDLOOP.
  SORT lt_functions BY funcname.
  DELETE ADJACENT DUPLICATES FROM lt_functions COMPARING funcname.
  lv_table = 'TFDIR'.
  CREATE DATA lr_tfdir TYPE (lv_table).
  ASSIGN lr_tfdir->* TO <ls_tfdir>.
  ASSIGN COMPONENT 'FUNCNAME' OF STRUCTURE <ls_tfdir> TO <lv_value>.
  IF sy-subrc <> 0.
    gs_object-status = 'FAILED'.
    gs_object-reason = 'TFDIR FUNCNAME unavailable'.
    PERFORM log USING gv_stage 'FAILED' gs_object-reason. RETURN.
  ENDIF.
  ASSIGN COMPONENT 'PNAME' OF STRUCTURE <ls_tfdir> TO <lv_value>.
  IF sy-subrc <> 0.
    gs_object-status = 'FAILED'.
    gs_object-reason = 'TFDIR PNAME unavailable'.
    PERFORM log USING gv_stage 'FAILED' gs_object-reason. RETURN.
  ENDIF.
  LOOP AT lt_functions INTO ls_function.
    lv_index = sy-tabix.
    lv_function = ls_function-funcname.
    gv_component = lv_function.
    CLEAR <ls_tfdir>.
    lv_where = 'FUNCNAME = LV_FUNCTION'.
    SELECT SINGLE * FROM (lv_table) INTO <ls_tfdir> WHERE (lv_where).
    IF sy-subrc <> 0.
      ADD 1 TO lv_errors.
      PERFORM log USING gv_stage 'FAILED' 'TFDIR function row absent'.
      CONTINUE.
    ENDIF.
    ASSIGN COMPONENT 'PNAME' OF STRUCTURE <ls_tfdir> TO <lv_value>.
    lv_name = <lv_value>.
    IF lv_name IS INITIAL OR strlen( lv_name ) > 40.
      ADD 1 TO lv_errors.
      PERFORM log USING gv_stage 'FAILED'
        'TFDIR main program empty or too long; skipped'.
      CONTINUE.
    ENDIF.
    ls_function-main_program = lv_name.
    MODIFY lt_functions FROM ls_function INDEX lv_index.
    INSERT ls_function-main_program INTO TABLE lt_mains.
  ENDLOOP.
  gv_payload_state = 'U'.
  CLEAR gv_file_language.
  CALL TRANSFORMATION id SOURCE group_name = lv_area
    functions = lt_functions RESULT XML lv_xml.
  PERFORM add_file USING 'Function Module/directory.xml' 'FUNCTION_DIRECTORY' lv_xml.
  CLEAR gv_payload_state.
  DESCRIBE TABLE lt_functions LINES lv_count.
  WRITE lv_count TO lv_count_text. CONDENSE lv_count_text.
  gv_component = gs_object-obj_name.
  CONCATENATE 'Function directory rows=' lv_count_text
    '; LANGUAGE=[' sy-langu '] INIT=[' gv_language_init
    '] START=[' gv_language_start ']' INTO lv_error.
  PERFORM log USING 'FUGR_DIRECTORY' 'INFO' lv_error.
  IF lt_functions IS INITIAL.
    PERFORM log USING 'FUGR_DIRECTORY' 'UNRESOLVED'
      'No function directory rows; no main program inferred from name'.
  ENDIF.
  gt_fugr_mains = lt_mains.
  LOOP AT lt_mains INTO lv_main.
    TRY.
        PERFORM program_file USING lv_main gs_object-devclass
          CHANGING lv_ok lv_excluded lt_source.
        IF lv_excluded = 'X'.
          INSERT lv_main INTO TABLE lt_excluded_mains.
        ELSEIF lv_ok IS INITIAL.
          ADD 1 TO lv_errors.
        ELSE.
          PERFORM scan_program USING lv_main lt_source.
        ENDIF.
      CATCH cx_root INTO lo_error.
        ADD 1 TO lv_errors.
        lv_error = lo_error->get_text( ).
        PERFORM log USING 'FUGR_MAIN' 'FAILED' lv_error.
    ENDTRY.
    IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  ENDLOOP.
  LOOP AT lt_functions INTO ls_function.
    READ TABLE lt_excluded_mains WITH TABLE KEY
      table_line = ls_function-main_program TRANSPORTING NO FIELDS.
    IF sy-subrc = 0. CONTINUE. ENDIF.
    IF ls_function-main_program IS INITIAL.
      ADD 1 TO lv_function_failed. CONTINUE.
    ENDIF.
    TRY.
        PERFORM function_file USING ls_function
          CHANGING lv_ok lv_container.
        IF lv_ok IS INITIAL.
          ADD 1 TO lv_errors.
          ADD 1 TO lv_function_failed.
        ELSE.
          ADD 1 TO lv_function_ok.
          IF lv_container = 'NEW_SOURCE'.
            ADD 1 TO lv_new_count.
          ELSEIF lv_container = 'SOURCE'.
            ADD 1 TO lv_source_count.
          ENDIF.
        ENDIF.
      CATCH cx_root INTO lo_error.
        ADD 1 TO lv_errors.
        ADD 1 TO lv_function_failed.
        lv_error = lo_error->get_text( ).
        PERFORM log USING 'FUNCTION_READ' 'FAILED' lv_error.
    ENDTRY.
    CLEAR: gv_payload_state, gv_file_language.
    IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  ENDLOOP.
  PERFORM export_owned_includes.
  IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  WRITE lv_function_ok TO lv_ok_text. CONDENSE lv_ok_text.
  WRITE lv_function_failed TO lv_failed_text. CONDENSE lv_failed_text.
  WRITE lv_source_count TO lv_source_text. CONDENSE lv_source_text.
  WRITE lv_new_count TO lv_new_text. CONDENSE lv_new_text.
  gv_component = gs_object-obj_name.
  CONCATENATE 'Functions completed=' lv_ok_text
    '; failed/skipped=' lv_failed_text
    '; SOURCE=' lv_source_text '; NEW_SOURCE=' lv_new_text
    INTO lv_error.
  PERFORM log USING 'FUGR_SUMMARY' 'INFO' lv_error.
  IF lv_errors > 0.
    gs_object-status = 'FAILED'.
    gs_object-reason = 'One or more function group components failed'.
  ELSEIF lt_excluded_mains IS NOT INITIAL
     AND gs_object-status <> 'FAILED'.
    IF lv_function_ok = 0. gs_object-status = 'EXCLUDED'. ENDIF.
    gs_object-reason = 'Mains without readable active source excluded'.
  ENDIF.
ENDFORM.

FORM prepare_function_reader.
* Prefer the long-line reader only after checking its actual active
* interface and constructing NEW_SOURCE with its actual DDIC type.
* No static reference to a possibly absent function or RSFB_SOURCE type.
  TYPES: BEGIN OF ty_binding,
           parameter TYPE fupararef-parameter,
           paramtype TYPE fupararef-paramtype,
           structure TYPE fupararef-structure,
         END OF ty_binding.
  DATA: lt_expected TYPE STANDARD TABLE OF ty_binding,
        ls_expected TYPE ty_binding,
        ls_meta TYPE fupararef,
        lt_specs TYPE ty_lines,
        lv_spec TYPE string,
        lv_type TYPE string,
        lv_count TYPE i,
        lr_line TYPE REF TO data,
        lv_kind TYPE c LENGTH 1,
        lv_length TYPE i,
        lo_error TYPE REF TO cx_root.
  FIELD-SYMBOLS: <lt_source> TYPE STANDARD TABLE,
                 <ls_line> TYPE ANY,
                 <lv_text> TYPE ANY,
                 <lv_extra> TYPE ANY.
  IF gv_fm_prepared = 'X'. RETURN. ENDIF.
  gv_fm_prepared = 'X'.
  gv_function_api = 'RPY_FUNCTIONMODULE_READ'.
  gv_api_reason = 'Legacy reader; long-line support not verified'.
  TRY.
      SELECT * FROM fupararef INTO TABLE gt_new_api_meta
        WHERE funcname = 'RPY_FUNCTIONMODULE_READ_NEW'
          AND r3state = 'A'.
      IF gt_new_api_meta IS INITIAL.
        gv_api_reason = 'NEW reader has no active FUPARAREF entries'.
        RETURN.
      ENDIF.
      SORT gt_new_api_meta BY parameter paramtype.
      APPEND 'FUNCTIONNAME|I|RS38L-NAME' TO lt_specs.
      APPEND 'FUNCTION_POOL|E|RS38L-AREA' TO lt_specs.
      APPEND 'GLOBAL_FLAG|E|RS38L-GLOBAL' TO lt_specs.
      APPEND 'REMOTE_CALL|E|RS38L-REMOTE' TO lt_specs.
      APPEND 'UPDATE_TASK|E|RS38L-UTASK' TO lt_specs.
      APPEND 'IMPORT_PARAMETER|T|RSIMP' TO lt_specs.
      APPEND 'CHANGING_PARAMETER|T|RSCHA' TO lt_specs.
      APPEND 'EXPORT_PARAMETER|T|RSEXP' TO lt_specs.
      APPEND 'TABLES_PARAMETER|T|RSTBL' TO lt_specs.
      APPEND 'EXCEPTION_LIST|T|RSEXC' TO lt_specs.
      APPEND 'DOCUMENTATION|T|RSFDO' TO lt_specs.
      APPEND 'SOURCE|T|RSSOURCE' TO lt_specs.
      APPEND 'FUNCTION_NOT_FOUND|X|' TO lt_specs.
      APPEND 'INVALID_NAME|X|' TO lt_specs.
      LOOP AT lt_specs INTO lv_spec.
        CLEAR ls_expected.
        SPLIT lv_spec AT '|' INTO ls_expected-parameter
          ls_expected-paramtype ls_expected-structure.
        APPEND ls_expected TO lt_expected.
      ENDLOOP.
      LOOP AT lt_expected INTO ls_expected.
        CLEAR lv_count.
        LOOP AT gt_new_api_meta INTO ls_meta
          WHERE parameter = ls_expected-parameter
            AND paramtype = ls_expected-paramtype.
          ADD 1 TO lv_count.
        ENDLOOP.
        IF lv_count <> 1 OR ls_meta-structure <> ls_expected-structure
          OR ls_meta-ref_class IS NOT INITIAL
          OR ls_meta-line_of IS NOT INITIAL
          OR ls_meta-table_of IS NOT INITIAL.
          CONCATENATE 'NEW interface differs at'
            ls_expected-parameter INTO gv_api_reason SEPARATED BY space.
          RETURN.
        ENDIF.
      ENDLOOP.
      CLEAR lv_count.
      LOOP AT gt_new_api_meta INTO ls_meta
        WHERE parameter = 'NEW_SOURCE' AND paramtype = 'C'.
        ADD 1 TO lv_count.
      ENDLOOP.
      IF lv_count <> 1 OR ls_meta-structure IS INITIAL OR
         ls_meta-ref_class IS NOT INITIAL OR
         ls_meta-line_of IS NOT INITIAL OR
         ls_meta-table_of IS NOT INITIAL.
        gv_api_reason = 'NEW_SOURCE changing table type unresolved'.
        RETURN.
      ENDIF.
      lv_type = ls_meta-structure.
      CLEAR ls_expected.
      ls_expected-parameter = 'NEW_SOURCE'.
      ls_expected-paramtype = 'C'.
      APPEND ls_expected TO lt_expected.
* Reject an additional mandatory caller input, not just missing outputs.
      LOOP AT gt_new_api_meta INTO ls_meta.
        IF ls_meta-paramtype <> 'I' AND ls_meta-paramtype <> 'C'
          AND ls_meta-paramtype <> 'T'. CONTINUE. ENDIF.
        READ TABLE lt_expected WITH KEY parameter = ls_meta-parameter
          paramtype = ls_meta-paramtype TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0 AND ls_meta-optional IS INITIAL AND
           ls_meta-defaultval IS INITIAL.
          CONCATENATE 'NEW reader needs additional input'
            ls_meta-parameter INTO gv_api_reason SEPARATED BY space.
          RETURN.
        ENDIF.
      ENDLOOP.
      CREATE DATA gr_new_source TYPE (lv_type).
      ASSIGN gr_new_source->* TO <lt_source>.
      IF sy-subrc <> 0.
        gv_api_reason = 'NEW_SOURCE is not a standard table'. RETURN.
      ENDIF.
      CREATE DATA lr_line LIKE LINE OF <lt_source>.
      ASSIGN lr_line->* TO <ls_line>.
      DESCRIBE FIELD <ls_line> TYPE lv_kind.
      IF lv_kind = 'C' OR lv_kind = 'g'.
        ASSIGN <ls_line> TO <lv_text>.
      ELSEIF lv_kind = 'u' OR lv_kind = 'v'.
        ASSIGN COMPONENT 2 OF STRUCTURE <ls_line> TO <lv_extra>.
        IF sy-subrc = 0.
          gv_api_reason = 'NEW_SOURCE row has multiple fields'. RETURN.
        ENDIF.
        ASSIGN COMPONENT 1 OF STRUCTURE <ls_line> TO <lv_text>.
      ENDIF.
      IF <lv_text> IS NOT ASSIGNED.
        gv_api_reason = 'NEW_SOURCE text field unresolved'. RETURN.
      ENDIF.
      DESCRIBE FIELD <lv_text> TYPE lv_kind.
      IF lv_kind = 'C'.
        DESCRIBE FIELD <lv_text> LENGTH lv_length IN CHARACTER MODE.
        IF lv_length < 255.
          gv_api_reason = 'NEW_SOURCE character width below 255'. RETURN.
        ENDIF.
      ELSEIF lv_kind <> 'g'.
        gv_api_reason = 'NEW_SOURCE is not character-like'. RETURN.
      ENDIF.
      gv_function_api = 'RPY_FUNCTIONMODULE_READ_NEW'.
      CONCATENATE 'Active interface matched; NEW_SOURCE type=' lv_type
        INTO gv_api_reason.
    CATCH cx_root INTO lo_error.
      gv_api_reason = lo_error->get_text( ).
      CONCATENATE 'NEW reader unavailable:' gv_api_reason
        INTO gv_api_reason SEPARATED BY space.
  ENDTRY.
ENDFORM.

FORM choose_function_source USING pv_source_rows TYPE i
                                  pv_new_rows TYPE i
                            CHANGING cv_container TYPE c.
* Called only after the API return code and function pool are checked.
* Both SOURCE and NEW_SOURCE are legitimate outputs of the NEW API.
* Prefer the wider output if present; do not convert or merge its rows.
  CLEAR cv_container.
  IF pv_new_rows > 0.
    cv_container = 'NEW_SOURCE'.
  ELSEIF pv_source_rows > 0.
    cv_container = 'SOURCE'.
  ENDIF.
ENDFORM.

FORM test_function_source_choice.
  DATA: lv_source_rows TYPE i,
        lv_new_rows TYPE i,
        lv_container TYPE c LENGTH 10.
* Wide-only, narrow-only after wide, both, and neither after both.
* Reusing the output verifies that an empty result clears stale state.
  lv_source_rows = 0. lv_new_rows = 2.
  PERFORM choose_function_source USING lv_source_rows lv_new_rows
    CHANGING lv_container.
  IF lv_container <> 'NEW_SOURCE'.
    gv_fatal = 'Function wide source selection failed'. RETURN.
  ENDIF.
  lv_source_rows = 3. lv_new_rows = 0.
  PERFORM choose_function_source USING lv_source_rows lv_new_rows
    CHANGING lv_container.
  IF lv_container <> 'SOURCE'.
    gv_fatal = 'Function short source selection failed'. RETURN.
  ENDIF.
  lv_source_rows = 3. lv_new_rows = 2.
  PERFORM choose_function_source USING lv_source_rows lv_new_rows
    CHANGING lv_container.
  IF lv_container <> 'NEW_SOURCE'.
    gv_fatal = 'Function source priority failed'. RETURN.
  ENDIF.
  lv_source_rows = 0. lv_new_rows = 0.
  PERFORM choose_function_source USING lv_source_rows lv_new_rows
    CHANGING lv_container.
  IF lv_container IS NOT INITIAL.
    gv_fatal = 'Function empty source selection failed'. RETURN.
  ENDIF.
ENDFORM.

FORM function_file USING ps_function TYPE ty_function
                   CHANGING cv_ok TYPE c cv_container TYPE c.
  DATA: lv_function TYPE rs38l-name,
        lv_pool TYPE rs38l-area,
        lv_global TYPE rs38l-global,
        lv_remote TYPE rs38l-remote,
        lv_update TYPE rs38l-utask,
        lt_import TYPE STANDARD TABLE OF rsimp,
        lt_change TYPE STANDARD TABLE OF rscha,
        lt_export TYPE STANDARD TABLE OF rsexp,
        lt_tables TYPE STANDARD TABLE OF rstbl,
        lt_except TYPE STANDARD TABLE OF rsexc,
        lt_doc TYPE STANDARD TABLE OF rsfdo,
        lt_source TYPE STANDARD TABLE OF rssource,
        lv_segment TYPE string,
        lv_prefix TYPE string,
        lv_path TYPE string,
        lv_text TYPE string,
        lv_xml TYPE xstring,
        lv_kind TYPE c LENGTH 1,
        lv_container TYPE c LENGTH 10,
        lv_source_rows TYPE i,
        lv_new_rows TYPE i,
        lv_rc TYPE sy-subrc,
        lv_rc_text TYPE c LENGTH 12,
        lv_language_before TYPE sy-langu,
        lv_language_after TYPE sy-langu,
        lv_msgid TYPE sy-msgid,
        lv_msgno TYPE sy-msgno,
        lv_msgty TYPE sy-msgty,
        lv_msgv1 TYPE sy-msgv1,
        lv_msgv2 TYPE sy-msgv2,
        lv_msgv3 TYPE sy-msgv3,
        lv_msgv4 TYPE sy-msgv4,
        lv_message TYPE string,
        lv_ok TYPE c LENGTH 1,
        lo_error TYPE REF TO cx_root.
  FIELD-SYMBOLS: <lt_new> TYPE STANDARD TABLE,
                 <lt_chosen> TYPE STANDARD TABLE,
                 <ls_source> TYPE ANY,
                 <lv_line> TYPE ANY,
                 <lv_extra> TYPE ANY.
  CLEAR: cv_ok, cv_container.
  gv_stage = 'FUNCTION_READ'.
  gv_component = ps_function-funcname.
  CLEAR gv_file_language.
  gv_payload_state = 'U'.
  lv_function = ps_function-funcname.
* Neither API promises an active version or translated interfaces.
  lv_language_before = sy-langu.
  TRY.
      IF gv_function_api = 'RPY_FUNCTIONMODULE_READ_NEW'.
        ASSIGN gr_new_source->* TO <lt_new>.
        REFRESH <lt_new>.
        CALL FUNCTION gv_function_api
          EXPORTING functionname = lv_function
          IMPORTING function_pool = lv_pool global_flag = lv_global
            remote_call = lv_remote update_task = lv_update
          TABLES import_parameter = lt_import
            changing_parameter = lt_change export_parameter = lt_export
            tables_parameter = lt_tables exception_list = lt_except
            documentation = lt_doc source = lt_source
          CHANGING new_source = <lt_new>
          EXCEPTIONS error_message = 1 function_not_found = 2
            invalid_name = 3 OTHERS = 4.
      ELSE.
        CALL FUNCTION 'RPY_FUNCTIONMODULE_READ'
          EXPORTING functionname = lv_function
          IMPORTING function_pool = lv_pool global_flag = lv_global
            remote_call = lv_remote update_task = lv_update
          TABLES import_parameter = lt_import
            changing_parameter = lt_change export_parameter = lt_export
            tables_parameter = lt_tables exception_list = lt_except
            documentation = lt_doc source = lt_source
          EXCEPTIONS error_message = 1 function_not_found = 2
            invalid_name = 3 OTHERS = 4.
      ENDIF.
      lv_rc = sy-subrc.
      lv_language_after = sy-langu.
      lv_msgid = sy-msgid. lv_msgno = sy-msgno. lv_msgty = sy-msgty.
      lv_msgv1 = sy-msgv1. lv_msgv2 = sy-msgv2.
      lv_msgv3 = sy-msgv3. lv_msgv4 = sy-msgv4.
    CATCH cx_root INTO lo_error.
      gv_error = lo_error->get_text( ).
      PERFORM log USING 'FUNCTION_READ' 'FAILED' gv_error. RETURN.
  ENDTRY.
  PERFORM segment USING ps_function-funcname CHANGING lv_segment.
  CONCATENATE 'Function Module/' lv_segment '/' INTO lv_prefix.
  IF lv_rc <> 0 OR lv_pool <> ps_function-area.
    IF lv_rc <> 0 AND lv_msgid IS NOT INITIAL.
      MESSAGE ID lv_msgid TYPE 'S' NUMBER lv_msgno
        WITH lv_msgv1 lv_msgv2 lv_msgv3 lv_msgv4 INTO lv_message.
    ENDIF.
    WRITE lv_rc TO lv_rc_text. CONDENSE lv_rc_text.
    CONCATENATE 'API=' gv_function_api '; SUBRC=' lv_rc_text
      '; POOL=' lv_pool '; MSGID=' lv_msgid '; MSGNO=' lv_msgno
      '; TEXT=' lv_message INTO gv_error.
    PERFORM log USING 'FUNCTION_READ' 'FAILED' gv_error.
    CALL TRANSFORMATION id SOURCE function_name = lv_function
      api_name = gv_function_api read_subrc = lv_rc pool = lv_pool
      expected_pool = ps_function-area message_id = lv_msgid
      message_number = lv_msgno message_type = lv_msgty
      message_v1 = lv_msgv1 message_v2 = lv_msgv2
      message_v3 = lv_msgv3 message_v4 = lv_msgv4
      message_text = lv_message RESULT XML lv_xml.
    CONCATENATE lv_prefix 'read-error.xml' INTO lv_path.
    PERFORM add_file USING lv_path 'FUNCTION_READ_DIAGNOSTIC' lv_xml.
    RETURN.
  ENDIF.
  DESCRIBE TABLE lt_source LINES lv_source_rows.
  IF <lt_new> IS ASSIGNED.
    DESCRIBE TABLE <lt_new> LINES lv_new_rows.
  ENDIF.
  PERFORM choose_function_source USING lv_source_rows lv_new_rows
    CHANGING lv_container.
  IF lv_container IS INITIAL.
    PERFORM log USING 'FUNCTION_READ' 'FAILED'
      'API returned no source rows; SOURCE=0; NEW_SOURCE=0'.
    CALL TRANSFORMATION id SOURCE function_name = lv_function
      api_name = gv_function_api read_subrc = lv_rc pool = lv_pool
      source_rows = lv_source_rows new_source_rows = lv_new_rows
      RESULT XML lv_xml.
    CONCATENATE lv_prefix 'read-error.xml' INTO lv_path.
    PERFORM add_file USING lv_path 'FUNCTION_READ_DIAGNOSTIC' lv_xml.
    RETURN.
  ELSEIF lv_container = 'NEW_SOURCE'.
    ASSIGN <lt_new> TO <lt_chosen>.
  ELSE.
    ASSIGN lt_source TO <lt_chosen>.
  ENDIF.
  PERFORM function_attributes USING ps_function lv_prefix
    lv_global lv_remote lv_update CHANGING gv_error.
  IF gv_error IS NOT INITIAL.
    PERFORM log USING 'FUNCTION_ATTRIBUTES' 'FAILED' gv_error. RETURN.
  ENDIF.
  PERFORM function_tab USING lv_prefix 'Import' lt_import lt_doc
    CHANGING gv_error.
  IF gv_error IS NOT INITIAL. RETURN. ENDIF.
  PERFORM function_tab USING lv_prefix 'Export' lt_export lt_doc
    CHANGING gv_error.
  IF gv_error IS NOT INITIAL. RETURN. ENDIF.
  PERFORM function_tab USING lv_prefix 'Changing' lt_change lt_doc
    CHANGING gv_error.
  IF gv_error IS NOT INITIAL. RETURN. ENDIF.
  PERFORM function_tab USING lv_prefix 'Tables' lt_tables lt_doc
    CHANGING gv_error.
  IF gv_error IS NOT INITIAL. RETURN. ENDIF.
  PERFORM function_tab USING lv_prefix 'Exception' lt_except lt_doc
    CHANGING gv_error.
  IF gv_error IS NOT INITIAL. RETURN. ENDIF.
  LOOP AT <lt_chosen> ASSIGNING <ls_source>.
    UNASSIGN <lv_line>.
    DESCRIBE FIELD <ls_source> TYPE lv_kind.
    IF lv_kind = 'C' OR lv_kind = 'g'.
      ASSIGN <ls_source> TO <lv_line>.
    ELSEIF lv_kind = 'u' OR lv_kind = 'v'.
      ASSIGN COMPONENT 2 OF STRUCTURE <ls_source> TO <lv_extra>.
      IF sy-subrc = 0.
        PERFORM log USING 'FUNCTION_READ' 'FAILED'
          'Source has multiple fields; source not exported'. RETURN.
      ENDIF.
      ASSIGN COMPONENT 1 OF STRUCTURE <ls_source> TO <lv_line>.
    ENDIF.
    IF <lv_line> IS NOT ASSIGNED.
      PERFORM log USING 'FUNCTION_READ' 'FAILED'
        'Source line shape unresolved; source not exported'. RETURN.
    ENDIF.
    DESCRIBE FIELD <lv_line> TYPE lv_kind.
    IF lv_kind <> 'C' AND lv_kind <> 'g'.
      PERFORM log USING 'FUNCTION_READ' 'FAILED'
        'Source text field is not character-like'. RETURN.
    ENDIF.
    CONCATENATE lv_text <lv_line> gv_lf INTO lv_text
      RESPECTING BLANKS.
  ENDLOOP.
  CONCATENATE lv_prefix 'Source code/' lv_segment '.abap'
    INTO lv_path.
  PERFORM add_text USING lv_path 'FUNCTION_API_SOURCE' lv_text.

  cv_container = lv_container.
  cv_ok = 'X'.
ENDFORM.




FORM ddic_failure_probe.
* Only repository header metadata; never read business records or fall
* back silently to an inactive definition. Keep the object FAILED.
  DATA: lr_rows TYPE REF TO data,
        lr_row TYPE REF TO data,
        lv_table TYPE c LENGTH 30,
        lv_name TYPE ddobjname,
        lv_where TYPE string,
        lv_xml TYPE xstring,
        lv_rc TYPE sy-subrc,
        lv_count TYPE i,
        lv_count_text TYPE c LENGTH 12,
        lv_local TYPE string,
        lv_vers TYPE string,
        lv_class TYPE string,
        lv_error TYPE string,
        lo_error TYPE REF TO cx_root.
  FIELD-SYMBOLS: <lt_rows> TYPE STANDARD TABLE,
                 <ls_row> TYPE ANY,
                 <lv_value> TYPE ANY.
  IF gs_object-object <> 'TABL'. RETURN. ENDIF.
  gv_component = gs_object-obj_name.
  CLEAR gv_file_language.
  gv_payload_state = 'U'.
  TRY.
      lv_table = 'DD02L'.
      CREATE DATA lr_rows TYPE STANDARD TABLE OF (lv_table).
      CREATE DATA lr_row TYPE (lv_table).
      ASSIGN lr_rows->* TO <lt_rows>.
      ASSIGN lr_row->* TO <ls_row>.
      ASSIGN COMPONENT 'TABNAME' OF STRUCTURE <ls_row> TO <lv_value>.
      IF sy-subrc <> 0.
        PERFORM log USING 'DDIC_STATE_PROBE' 'UNRESOLVED'
          'DD02L TABNAME unavailable'.
        CLEAR gv_payload_state. RETURN.
      ENDIF.
      lv_name = gs_object-obj_name.
      lv_where = 'TABNAME = LV_NAME'.
      SELECT * FROM (lv_table) INTO TABLE <lt_rows> WHERE (lv_where).
      lv_rc = sy-subrc.
      SORT <lt_rows>.
      CALL TRANSFORMATION id SOURCE object_name = lv_name
        read_subrc = lv_rc repository_headers = <lt_rows>
        RESULT XML lv_xml.
      PERFORM add_file USING 'diagnostic-dd02l.xml'
        'DDIC_STATE_DIAGNOSTIC' lv_xml.
      DESCRIBE TABLE <lt_rows> LINES lv_count.
      WRITE lv_count TO lv_count_text. CONDENSE lv_count_text.
      CONCATENATE 'DD02L header rows=' lv_count_text
        '; see diagnostic-dd02l.xml; object remains FAILED'
        INTO lv_error RESPECTING BLANKS.
      PERFORM log USING 'DDIC_STATE_PROBE' 'INFO' lv_error.
      LOOP AT <lt_rows> ASSIGNING <ls_row>.
        lv_local = '<field unavailable>'.
        lv_vers = '<field unavailable>'.
        lv_class = '<field unavailable>'.
        ASSIGN COMPONENT 'AS4LOCAL' OF STRUCTURE <ls_row>
          TO <lv_value>.
        IF sy-subrc = 0. lv_local = <lv_value>. ENDIF.
        ASSIGN COMPONENT 'AS4VERS' OF STRUCTURE <ls_row>
          TO <lv_value>.
        IF sy-subrc = 0. lv_vers = <lv_value>. ENDIF.
        ASSIGN COMPONENT 'TABCLASS' OF STRUCTURE <ls_row>
          TO <lv_value>.
        IF sy-subrc = 0. lv_class = <lv_value>. ENDIF.
        CONCATENATE 'AS4LOCAL=[' lv_local '] AS4VERS=[' lv_vers
          '] TABCLASS=[' lv_class ']' INTO lv_error.
        PERFORM log USING 'DDIC_STATE_DETAIL' 'INFO' lv_error.
      ENDLOOP.
    CATCH cx_root INTO lo_error.
      lv_error = lo_error->get_text( ).
      PERFORM log USING 'DDIC_STATE_PROBE' 'UNRESOLVED' lv_error.
  ENDTRY.
  CLEAR gv_payload_state.
ENDFORM.


FORM export_ddic.
  DATA: lv_name TYPE ddobjname,
        lv_state TYPE ddgotstate,
        lv_lang TYPE sy-langu,
        lv_iso TYPE c LENGTH 2,
        lv_ddic_dir TYPE string, lv_pkg TYPE string,
        lv_object_name TYPE string,
        lv_xml TYPE xstring,
        lv_rel TYPE string,
        lv_rc TYPE sy-subrc,
        lv_rc_text TYPE c LENGTH 12.
  DATA: ls_dd01v TYPE dd01v.
  DATA: ls_dd02v TYPE dd02v.
  DATA: ls_dd04v TYPE dd04v.
  DATA: ls_dd09v TYPE dd09v.
  DATA: ls_dd25v TYPE dd25v.
  DATA: ls_dd30v TYPE dd30v.
  DATA: ls_dd40v TYPE dd40v.
  DATA: ls_tpara TYPE tpara.
  DATA: lt_dd03p TYPE STANDARD TABLE OF dd03p.
  DATA: lt_dd05m TYPE STANDARD TABLE OF dd05m.
  DATA: lt_dd07v TYPE STANDARD TABLE OF dd07v.
  DATA: lt_dd08v TYPE STANDARD TABLE OF dd08v.
  DATA: lt_dd12v TYPE STANDARD TABLE OF dd12v.
  DATA: lt_dd17v TYPE STANDARD TABLE OF dd17v.
  DATA: lt_dd26v TYPE STANDARD TABLE OF dd26v.
  DATA: lt_dd27p TYPE STANDARD TABLE OF dd27p.
  DATA: lt_dd28j TYPE STANDARD TABLE OF dd28j.
  DATA: lt_dd28v TYPE STANDARD TABLE OF dd28v.
  DATA: lt_dd31v TYPE STANDARD TABLE OF dd31v.
  DATA: lt_dd32p TYPE STANDARD TABLE OF dd32p.
  DATA: lt_dd33v TYPE STANDARD TABLE OF dd33v.
  DATA: lt_dd35v TYPE STANDARD TABLE OF dd35v.
  DATA: lt_dd36m TYPE STANDARD TABLE OF dd36m.
  DATA: lt_dd42v TYPE STANDARD TABLE OF dd42v.
  lv_name = gs_object-obj_name.
  gv_stage = 'DDIC_READ'.
  PERFORM korean_language CHANGING lv_lang lv_iso.
  DO 2 TIMES.
    CLEAR: lv_state, lv_xml.
    CLEAR ls_dd01v.
    CLEAR ls_dd02v.
    CLEAR ls_dd04v.
    CLEAR ls_dd09v.
    CLEAR ls_dd25v.
    CLEAR ls_dd30v.
    CLEAR ls_dd40v.
    CLEAR ls_tpara.
    REFRESH lt_dd03p.
    REFRESH lt_dd05m.
    REFRESH lt_dd07v.
    REFRESH lt_dd08v.
    REFRESH lt_dd12v.
    REFRESH lt_dd17v.
    REFRESH lt_dd26v.
    REFRESH lt_dd27p.
    REFRESH lt_dd28j.
    REFRESH lt_dd28v.
    REFRESH lt_dd31v.
    REFRESH lt_dd32p.
    REFRESH lt_dd33v.
    REFRESH lt_dd35v.
    REFRESH lt_dd36m.
    REFRESH lt_dd42v.
    CASE gs_object-object.
      WHEN 'TABL'.
        CALL FUNCTION 'DDIF_TABL_GET'
          EXPORTING name = lv_name state = 'A' langu = lv_lang
          IMPORTING gotstate = lv_state
            dd02v_wa = ls_dd02v
            dd09l_wa = ls_dd09v
          TABLES
            dd03p_tab = lt_dd03p
            dd05m_tab = lt_dd05m
            dd08v_tab = lt_dd08v
            dd12v_tab = lt_dd12v
            dd17v_tab = lt_dd17v
            dd35v_tab = lt_dd35v
            dd36m_tab = lt_dd36m
          EXCEPTIONS illegal_input = 1 OTHERS = 2.
        lv_rc = sy-subrc.
        IF lv_rc = 0 AND lv_state = 'A'.
          CALL TRANSFORMATION id
            SOURCE requested_iso_language = lv_iso
      requested_language = lv_lang gotstate = lv_state
              dd02v_wa = ls_dd02v
              dd09l_wa = ls_dd09v
              dd03p_tab = lt_dd03p
              dd05m_tab = lt_dd05m
              dd08v_tab = lt_dd08v
              dd12v_tab = lt_dd12v
              dd17v_tab = lt_dd17v
              dd35v_tab = lt_dd35v
              dd36m_tab = lt_dd36m
            RESULT XML lv_xml.
        ENDIF.
      WHEN 'DTEL'.
        CALL FUNCTION 'DDIF_DTEL_GET'
          EXPORTING name = lv_name state = 'A' langu = lv_lang
          IMPORTING gotstate = lv_state
            dd04v_wa = ls_dd04v
            tpara_wa = ls_tpara
          EXCEPTIONS illegal_input = 1 OTHERS = 2.
        lv_rc = sy-subrc.
        IF lv_rc = 0 AND lv_state = 'A'.
          CALL TRANSFORMATION id
            SOURCE requested_iso_language = lv_iso
      requested_language = lv_lang gotstate = lv_state
              dd04v_wa = ls_dd04v
              tpara_wa = ls_tpara
            RESULT XML lv_xml.
        ENDIF.
      WHEN 'DOMA'.
        CALL FUNCTION 'DDIF_DOMA_GET'
          EXPORTING name = lv_name state = 'A' langu = lv_lang
          IMPORTING gotstate = lv_state
            dd01v_wa = ls_dd01v
          TABLES
            dd07v_tab = lt_dd07v
          EXCEPTIONS illegal_input = 1 OTHERS = 2.
        lv_rc = sy-subrc.
        IF lv_rc = 0 AND lv_state = 'A'.
          CALL TRANSFORMATION id
            SOURCE requested_iso_language = lv_iso
      requested_language = lv_lang gotstate = lv_state
              dd01v_wa = ls_dd01v
              dd07v_tab = lt_dd07v
            RESULT XML lv_xml.
        ENDIF.
      WHEN 'VIEW'.
        CALL FUNCTION 'DDIF_VIEW_GET'
          EXPORTING name = lv_name state = 'A' langu = lv_lang
          IMPORTING gotstate = lv_state
            dd25v_wa = ls_dd25v
            dd09l_wa = ls_dd09v
          TABLES
            dd26v_tab = lt_dd26v
            dd27p_tab = lt_dd27p
            dd28j_tab = lt_dd28j
            dd28v_tab = lt_dd28v
          EXCEPTIONS illegal_input = 1 OTHERS = 2.
        lv_rc = sy-subrc.
        IF lv_rc = 0 AND lv_state = 'A'.
          CALL TRANSFORMATION id
            SOURCE requested_iso_language = lv_iso
      requested_language = lv_lang gotstate = lv_state
              dd25v_wa = ls_dd25v
              dd09l_wa = ls_dd09v
              dd26v_tab = lt_dd26v
              dd27p_tab = lt_dd27p
              dd28j_tab = lt_dd28j
              dd28v_tab = lt_dd28v
            RESULT XML lv_xml.
        ENDIF.
      WHEN 'TTYP'.
        CALL FUNCTION 'DDIF_TTYP_GET'
          EXPORTING name = lv_name state = 'A' langu = lv_lang
          IMPORTING gotstate = lv_state
            dd40v_wa = ls_dd40v
          TABLES
            dd42v_tab = lt_dd42v
          EXCEPTIONS illegal_input = 1 OTHERS = 2.
        lv_rc = sy-subrc.
        IF lv_rc = 0 AND lv_state = 'A'.
          CALL TRANSFORMATION id
            SOURCE requested_iso_language = lv_iso
      requested_language = lv_lang gotstate = lv_state
              dd40v_wa = ls_dd40v
              dd42v_tab = lt_dd42v
            RESULT XML lv_xml.
        ENDIF.
      WHEN 'SHLP'.
        CALL FUNCTION 'DDIF_SHLP_GET'
          EXPORTING name = lv_name state = 'A' langu = lv_lang
          IMPORTING gotstate = lv_state
            dd30v_wa = ls_dd30v
          TABLES
            dd31v_tab = lt_dd31v
            dd32p_tab = lt_dd32p
            dd33v_tab = lt_dd33v
          EXCEPTIONS illegal_input = 1 OTHERS = 2.
        lv_rc = sy-subrc.
        IF lv_rc = 0 AND lv_state = 'A'.
          CALL TRANSFORMATION id
            SOURCE requested_iso_language = lv_iso
      requested_language = lv_lang gotstate = lv_state
              dd30v_wa = ls_dd30v
              dd31v_tab = lt_dd31v
              dd32p_tab = lt_dd32p
              dd33v_tab = lt_dd33v
            RESULT XML lv_xml.
        ENDIF.
    ENDCASE.
    IF lv_rc <> 0 OR lv_state <> 'A' OR lv_xml IS INITIAL.
      IF lv_lang = gv_language_ko AND gv_language_en IS NOT INITIAL.
        PERFORM log USING 'LANGUAGE_RETRY' 'INFO'
          'KO DDIC read unavailable; trying the same active object in EN'.
        lv_lang = gv_language_en. lv_iso = 'EN'. CONTINUE.
      ENDIF.
      gs_object-status = 'FAILED'.
      WRITE lv_rc TO lv_rc_text.
      CONDENSE lv_rc_text.
      CONCATENATE 'DDIC active read failed; LANG=' lv_lang
        ' SUBRC=' lv_rc_text ' GOTSTATE=' lv_state
        INTO gs_object-reason RESPECTING BLANKS.
      gv_error = gs_object-reason.
      PERFORM log USING 'DDIC_READ' 'FAILED' gv_error.
      PERFORM ddic_failure_probe.
      RETURN.
    ENDIF.
    IF gs_object-object = 'TABL'.
      PERFORM ddic_table_folder USING ls_dd02v-tabclass
        CHANGING lv_ddic_dir.
      IF lv_ddic_dir IS INITIAL.
        gs_object-status = 'FAILED'.
        gs_object-reason = 'Active TABL classification is not supported'.
        PERFORM log USING 'DDIC_CLASS' 'FAILED' gs_object-reason.
        RETURN.
      ENDIF.
      PERFORM segment USING gs_object-devclass CHANGING lv_pkg.
      PERFORM segment USING gs_object-obj_name CHANGING lv_object_name.
      CONCATENATE 'packages/' lv_pkg '/Dictionary Object/'
        lv_ddic_dir '/' lv_object_name '/' INTO gv_root.
    ENDIF.
    IF lv_lang = gv_language_en AND gv_language_en IS NOT INITIAL.
      PERFORM log USING 'LANGUAGE_FALLBACK' 'INFO'
        'DDIC active API read succeeded on the EN retry'.
    ENDIF.
    gv_file_language = lv_lang.
    lv_rel = 'definition.xml'.
    PERFORM add_file USING lv_rel 'DDIC_DEFINITION' lv_xml.
    IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
    EXIT.
  ENDDO.
  CLEAR gv_file_language.
ENDFORM.

FORM finalize.
  DATA: lv_data TYPE xstring,
        lv_text TYPE string,
        lv_path TYPE string,
        lv_pkg TYPE string,
        lv_success TYPE i,
        lv_partial TYPE i,
        lv_failed TYPE i,
        lv_unsupported TYPE i,
        lv_excluded TYPE i,
        lv_skipped TYPE i,
        lv_count TYPE i.
  gv_stage = 'FINALIZE'.
  CLEAR gs_header.
  gs_header-format = 'DEVHUB-EXPORT'.
  gs_header-version = '0.2'.
  gs_header-tool_version = '0.3.18'.
  gs_header-korean_language_key = gv_language_ko.
  gs_header-english_language_key = gv_language_en.
  gs_header-language_policy = 'KO_FIRST_EN_FALLBACK'.
  gs_header-language_selection_format = 'ISO_639_1'.
  gs_header-language_at_initialization = gv_language_init.
  gs_header-language_at_start = gv_language_start.
  gs_header-sysid = sy-sysid.
  gs_header-client = sy-mandt.
  gs_header-basis = sy-saprl.
  gs_header-unicode = 'X'.
  gs_header-support_package_evidence =
    'Target screenshot: SAP_BASIS 700 SP0041; not measured by tool'.
  gs_header-dependency_policy = 'REFERENCE_ONLY_EXTERNAL'.
  gs_header-completeness = 'PARTIAL'.
  gs_header-dependency_coverage = 'OWNED_FUGR_INCLUDE_WALK_PARTIAL'.
  gs_header-import_enabled = ' '.
  gs_header-checksum_security =
    'CRC32 is not cryptographic; baseline bytes must be compared'.
  gs_header-normalization =
    'Per-file CHECK_MODE: LF_UTF8 or RAW; MIME stays byte-exact'.
  PERFORM finalize_mime.
  IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  PERFORM finalize_web.
  IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  SORT gt_files BY path.
  SORT gt_refs BY source_program source_line target_program
    target_package scope evidence optional.
  DELETE ADJACENT DUPLICATES FROM gt_refs COMPARING ALL FIELDS.
  CALL TRANSFORMATION id SOURCE header = gs_header
    packages = gt_packages include_subpackages = p_sub
    package_selection = s_pack[] languages = s_lang[]
    files = gt_files RESULT XML lv_data.
  lv_path = 'manifest.xml'.
  PERFORM add_xml_raw USING lv_path lv_data.
  CALL TRANSFORMATION id SOURCE objects = gt_objects RESULT XML lv_data.
  lv_path = 'catalog/objects.xml'.
  PERFORM add_xml_raw USING lv_path lv_data.
  CALL TRANSFORMATION id SOURCE references = gt_refs RESULT XML lv_data.
  lv_path = 'catalog/references.xml'.
  PERFORM add_xml_raw USING lv_path lv_data.
  CALL TRANSFORMATION id SOURCE messages = gt_logs RESULT XML lv_data.
  lv_path = 'logs/processing.xml'.
  PERFORM add_xml_raw USING lv_path lv_data.
  CALL TRANSFORMATION id SOURCE run_date = sy-datum run_time = sy-uzeit
    raw_payload_bytes_before_run_log = gv_bytes RESULT XML lv_data.
  lv_path = 'logs/run.xml'.
  PERFORM add_xml_raw USING lv_path lv_data.

  CONCATENATE '# DEVHUB export 0.3.18 - validation build' gv_lf gv_lf
    'This archive is PARTIAL and ANALYSIS_ONLY.' gv_lf
    'Start with catalog/objects.xml and catalog/references.xml.' gv_lf
    'Programs: source, KO-first text pools with EN fallback, TRDIR.' gv_lf
    'Unreadable first active source reads are excluded, not error logs.' gv_lf
    'Known MIME URL/DDIC XML omissions: SKIPPED, one WARNING per object.' gv_lf
    'These objects have no exported body; other errors remain FAILED.' gv_lf
    'Class bodies and class-reference diagnostics are outside scope.' gv_lf
    'Package children included; fixed uncompressed ZIP budget 512 MiB.' gv_lf
    'MessageClass/<class>/Messages.xml: KO first, EN for missing numbers.' gv_lf
    'Message long texts are not exported; no other-language fallback.' gv_lf
    'Dictionary Object: DBtable, Structures, TableType, Domain, Data element.' gv_lf
    'Other types, screens and GUI status are not serialized yet.' gv_lf
    'Function Module/<function>/: six tab XMLs and Source code/.'
      gv_lf
    'Function API version is UNVERIFIED; it has no STATE parameter.'
      gv_lf
    'Function long docs and screens remain incomplete.'
      gv_lf
    'BSP pages/events/parameters are read with explicit active version.' gv_lf
    'Page tabs: Properties.xml, Layout/, Event Handler/,' gv_lf
    'Page Attributes.xml and Type Definitions.abap.' gv_lf
    'Event source filenames use actual SAP handler identities.' gv_lf
    'BSP/function XML keeps API fields; formatted tag/value bytes checked.' gv_lf
    'Generated XML has indented lines; original web/MIME bytes stay raw.' gv_lf
    'MIME under an unselected BSP package is excluded before reading.' gv_lf
    'See catalog/web-assets.xml references for package exclusions.' gv_lf
    'BSP Application: pages/ and MIMEs/ with original MIME folders.' gv_lf
    'Standalone SMIM: MIME/<type>/<subtype>/<filename>; ID suffix on collision.' gv_lf
    'SMIM file/folder metadata: one MIME/metadata.xml per owning package.' gv_lf
    'W3MI keeps its object grouping under uppercase MIME/W3MI.' gv_lf
    '.devhub/baseline is the unedited comparison copy; do not index it for AI.' gv_lf
    'No generated language suffixes in paths; actual language stays in metadata.' gv_lf
    'Classes and OTR text export remain incomplete.' gv_lf
    'External or unresolved include owners are reference-only.' gv_lf
    'Include links are lexical direct edges; macro candidates marked.'
      gv_lf
    'Selected roots plus verified owned FUGR includes are scanned.'
      gv_lf
    'Same FUGR ownership requires split API, TADIR and main mapping.'
      gv_lf
    'Include/includes.xml records actual include read outcomes.'
      gv_lf
    'Dependency scan is partial; this is not an ABAP syntax parser.'
      gv_lf
    'No other static or dynamic dependency scan is implemented yet.' gv_lf
    'Do not treat absent files as object deletion.' gv_lf
    'Do not overlay this partial export onto an existing Git tree.' gv_lf
    'Extract into a NEW short Windows folder; inspect before copying.'
      gv_lf
    'Keep .devhub/baseline unchanged. No import is supported yet.' gv_lf
    'CRC32 is a checksum, not a secure proof or a conflict decision.'
      gv_lf
    'Object definitions were read without a global repository lock.'
      gv_lf
    'Repeated export must be compared after extraction, not ZIP bytes.'
      gv_lf
    'Execution timestamps exist only in logs/run.xml.' gv_lf
    'Git commit/push and SAP activation/CTS are separate operations.'
      gv_lf
    INTO lv_text RESPECTING BLANKS.
  PERFORM utf8 USING lv_text CHANGING lv_data.
  lv_path = 'README.md'.
  PERFORM add_raw USING lv_path lv_data.

  LOOP AT gt_packages INTO gs_package.
    PERFORM segment USING gs_package-devclass CHANGING lv_pkg.
    CONCATENATE 'packages/' lv_pkg '/README.md' INTO lv_path.
    CONCATENATE '# Package ' gs_package-devclass gv_lf gv_lf
      'See ../../catalog/objects.xml for all registered objects.' gv_lf
      'Source/definitions exported by this build are under this folder.'
        gv_lf
      'Unsupported objects are catalog entries, not deleted objects.'
        gv_lf
      'Original names; only unsafe Windows names use ~HH escaping.' gv_lf
      'Original names are preserved in the manifest and catalog.' gv_lf
      INTO lv_text RESPECTING BLANKS.
    PERFORM utf8 USING lv_text CHANGING lv_data.
    PERFORM add_raw USING lv_path lv_data.
  ENDLOOP.
  CONCATENATE '*.abap text eol=lf' gv_lf
    '*.xml text eol=lf' gv_lf '*.md text eol=lf' gv_lf
    '*.bin binary' gv_lf '*.zip binary' gv_lf
    '**/content/** -text' gv_lf
    '**/Layout/** -text' gv_lf
    '**/MIMEs/** -text' gv_lf
    '**/MIME/*/*/* -text' gv_lf
    '.devhub/baseline/** -text' gv_lf INTO lv_text
    RESPECTING BLANKS.
  PERFORM utf8 USING lv_text CHANGING lv_data.
  lv_path = '.gitattributes'.
  PERFORM add_raw USING lv_path lv_data.
  CONCATENATE '/logs/' gv_lf '*.zip' gv_lf INTO lv_text
    RESPECTING BLANKS.
  PERFORM utf8 USING lv_text CHANGING lv_data.
  lv_path = '.gitignore'.
  PERFORM add_raw USING lv_path lv_data.
  LOOP AT gt_objects INTO gs_object.
    CASE gs_object-status.
      WHEN 'SUCCESS'. ADD 1 TO lv_success.
      WHEN 'PARTIAL'. ADD 1 TO lv_partial.
      WHEN 'FAILED'. ADD 1 TO lv_failed.
      WHEN 'UNSUPPORTED'. ADD 1 TO lv_unsupported.
      WHEN 'EXCLUDED'. ADD 1 TO lv_excluded.
      WHEN 'SKIPPED'. ADD 1 TO lv_skipped.

      WHEN OTHERS.
        gv_fatal = 'Internal error: catalog object has no final status'.
        RETURN.
    ENDCASE.
  ENDLOOP.
  DESCRIBE TABLE gt_files LINES lv_count.
  WRITE: / 'SUCCESS:', lv_success, 'PARTIAL:', lv_partial,
         / 'FAILED:', lv_failed, 'UNSUPPORTED:', lv_unsupported,
         / 'EXCLUDED:', lv_excluded, 'SKIPPED (notes):', lv_skipped,
         / 'Content files (each also has a baseline copy):', lv_count,
         / 'Uncompressed payload bytes:', gv_bytes,
         / 'Overall completeness: PARTIAL. Import: disabled.'.
ENDFORM.

FORM download.
  DATA: lt_binary TYPE ty_binary,
        lv_line TYPE ty_binary_line,
        lv_size TYPE i,
        lv_pos TYPE i,
        lv_len TYPE i,
        lv_path TYPE string,
        lv_written TYPE i,
        lv_rc TYPE sy-subrc.
  gv_stage = 'DOWNLOAD'.
  lv_size = xstrlen( gv_zip ).
  WHILE lv_pos < lv_size.
    lv_len = lv_size - lv_pos.
    IF lv_len > 255. lv_len = 255. ENDIF.
    CLEAR lv_line.
    lv_line = gv_zip+lv_pos(lv_len).
    APPEND lv_line TO lt_binary.
    lv_pos = lv_pos + lv_len.
  ENDWHILE.
  lv_path = p_file.
  CALL METHOD cl_gui_frontend_services=>gui_download
    EXPORTING filename = lv_path filetype = 'BIN'
      bin_filesize = lv_size confirm_overwrite = 'X'
      show_transfer_status = 'X' write_lf_after_last_line = ' '
    IMPORTING filelength = lv_written
    CHANGING data_tab = lt_binary
    EXCEPTIONS OTHERS = 1.
  lv_rc = sy-subrc.
  IF lv_rc <> 0 OR lv_written <> lv_size.
    WRITE: / 'DOWNLOAD FAILED or cancelled. Do not use a partial file.',
           / 'SUBRC:', lv_rc, 'Reported bytes:', lv_written,
           / 'Expected bytes:', lv_size,
           / 'SAP message:', sy-msgid, sy-msgno,
             sy-msgv1, sy-msgv2, sy-msgv3, sy-msgv4.
    RETURN.
  ENDIF.
  WRITE: / 'ZIP DOWNLOAD COMPLETE:', p_file,
         / 'ZIP bytes:', lv_written,
         / 'This is a partial export; validate contents against SAP.'.
ENDFORM.

*---------------------------------------------------------------------*
* Web readers. Interface types match KSD/300 diagnostic result.txt.
* No SET_CHANGEABLE, SAVE, ACTIVATE or repository modification calls.
*---------------------------------------------------------------------*
FORM web_fail USING pv_detail TYPE csequence.
  gs_object-status = 'FAILED'.
  gs_object-reason = pv_detail.
  PERFORM log USING gv_stage 'FAILED' pv_detail.
ENDFORM.

FORM web_leaf USING pv_original TYPE string
              CHANGING cv_leaf TYPE string.
  DATA: lt_parts TYPE STANDARD TABLE OF string,
        lv_path TYPE string, lv_part TYPE string, lv_last TYPE i.
* Repository URL or WWWPARAMS filename may contain a full PC path.
* Keep the basename; full original path remains in metadata/catalog.
  lv_path = pv_original.
  REPLACE ALL OCCURRENCES OF '\' IN lv_path WITH '/'.
  SPLIT lv_path AT '/' INTO TABLE lt_parts.
  LOOP AT lt_parts INTO lv_part. ENDLOOP.
  lv_last = strlen( lv_path ).
  IF lv_last > 0.
    SUBTRACT 1 FROM lv_last.
    IF lv_path+lv_last(1) = '/'. CLEAR lv_part. ENDIF.
  ENDIF.
  IF lv_part IS INITIAL. lv_part = 'content.bin'. ENDIF.
  PERFORM safe_leaf USING lv_part CHANGING cv_leaf.
* Do not rename long names to content.*. add_raw checks the full path.
ENDFORM.

FORM web_lines USING pt_lines TYPE ANY TABLE
               CHANGING cv_text TYPE string cv_ok TYPE c.
  DATA: lv_kind TYPE c, lv_line TYPE string, lv_empty TYPE string.
  FIELD-SYMBOLS: <ls_line> TYPE ANY, <lv_text> TYPE ANY,
                 <lv_second> TYPE ANY.
  CLEAR: cv_text, cv_ok.
  LOOP AT pt_lines ASSIGNING <ls_line>.
    UNASSIGN <lv_text>.
    DESCRIBE FIELD <ls_line> TYPE lv_kind.
    IF lv_kind = 'u' OR lv_kind = 'v'.
      ASSIGN COMPONENT 1 OF STRUCTURE <ls_line> TO <lv_text>.
      IF sy-subrc <> 0. RETURN. ENDIF.
      ASSIGN COMPONENT 2 OF STRUCTURE <ls_line> TO <lv_second>.
      IF sy-subrc = 0. RETURN. ENDIF.
    ELSE.
      ASSIGN <ls_line> TO <lv_text>.
    ENDIF.
    DESCRIBE FIELD <lv_text> TYPE lv_kind.
    IF lv_kind <> 'C' AND lv_kind <> 'g'. RETURN. ENDIF.
    CONCATENATE <lv_text> lv_empty INTO lv_line RESPECTING BLANKS.
    CONCATENATE cv_text lv_line gv_lf INTO cv_text
      RESPECTING BLANKS.
  ENDLOOP.
  cv_ok = 'X'.
ENDFORM.

FORM web_blob USING pv_relative TYPE csequence
                    pv_component TYPE csequence pv_data TYPE xstring.
  gv_check_mode = 'RAW'.
  PERFORM add_file USING pv_relative pv_component pv_data.
  CLEAR gv_check_mode.
ENDFORM.

FORM web_init CHANGING cs_asset TYPE ty_web_asset.
  CLEAR cs_asset.
  cs_asset-object = gs_object-object.
  cs_asset-obj_name = gs_object-obj_name.
  cs_asset-devclass = gs_object-devclass.
  cs_asset-status = 'FAILED'.
ENDFORM.


FORM bsp_folder USING pv_original TYPE string
                CHANGING cv_folder TYPE string cv_error TYPE string.
  DATA: lt_parts TYPE STANDARD TABLE OF string,
        lv_path TYPE string, lv_name TYPE string,
        lv_length TYPE i, lv_last TYPE i, lv_dot TYPE i, lv_i TYPE i.
* Use the original page filename, not its HTML title or inventory index.
* Strip only its final extension; keep case and dots inside the stem.
  CLEAR: cv_folder, cv_error.
  lv_path = pv_original.
  REPLACE ALL OCCURRENCES OF '\' IN lv_path WITH '/'.
  SPLIT lv_path AT '/' INTO TABLE lt_parts.
  LOOP AT lt_parts INTO lv_name. ENDLOOP.
  lv_length = strlen( lv_path ).
  IF lv_length > 0.
    lv_last = lv_length - 1.
    IF lv_path+lv_last(1) = '/'. CLEAR lv_name. ENDIF.
  ENDIF.
  IF lv_name IS INITIAL OR lv_name = '.' OR lv_name = '..'.
    cv_error = 'BSP page filename is missing or invalid'. RETURN.
  ENDIF.
  lv_length = strlen( lv_name ).
  lv_last = lv_length - 1.
  DO lv_length TIMES.
    lv_i = sy-index - 1.
    IF lv_name+lv_i(1) = '.'. lv_dot = lv_i. ENDIF.
  ENDDO.
* Keep extensionless names, leading-dot names and terminal dots intact.
  IF lv_dot > 0 AND lv_dot < lv_last.
    lv_name = lv_name(lv_dot).
  ENDIF.
* Escape after removing the extension (e.g. CON.htm -> reserved CON).
  PERFORM safe_leaf USING lv_name CHANGING cv_folder.
ENDFORM.

FORM bsp_inventory_keys USING pt_pages TYPE o2pagelist
                               pv_app TYPE o2applname
                        CHANGING ct_keys TYPE ty_bsp_keys
                                 cv_failed TYPE i.
  DATA: ls_key TYPE o2pagkey, lv_detail TYPE string.
  FIELD-SYMBOLS: <ls_page> TYPE ANY, <lv_key> TYPE ANY.
  REFRESH ct_keys.
* Language and active version are fixed by the caller for this inventory.
* Repeated rows for one exact API key must not export that page twice.
  LOOP AT pt_pages ASSIGNING <ls_page>.
    CLEAR ls_key. ls_key-applname = pv_app.
    gv_stage = 'BSP_INVENTORY'. gv_component = pv_app.
    ASSIGN COMPONENT 'PAGEKEY' OF STRUCTURE <ls_page> TO <lv_key>.
    IF sy-subrc <> 0 OR <lv_key> IS INITIAL.
      PERFORM web_fail USING 'BSP inventory PAGEKEY missing'.
      ADD 1 TO cv_failed. CONTINUE.
    ENDIF.
    ls_key-pagekey = <lv_key>.
    IF ls_key-pagekey <> <lv_key>.
      PERFORM web_fail USING 'BSP PAGEKEY would be truncated'.
      ADD 1 TO cv_failed. CONTINUE.
    ENDIF.
    INSERT ls_key INTO TABLE ct_keys.
    IF sy-subrc <> 0.
      CONCATENATE 'Repeated inventory key exported once:'
        ls_key-pagekey INTO lv_detail SEPARATED BY space.
      PERFORM log USING 'BSP_DUPLICATE_KEY' 'INFO' lv_detail.
    ENDIF.
  ENDLOOP.
ENDFORM.

FORM bsp_read_header USING ps_key TYPE o2pagkey pv_lang TYPE sy-langu
                     CHANGING co_page TYPE REF TO cl_o2_api_pages
                              cs_attrs TYPE o2pagattr
                              cv_name TYPE string cv_stem TYPE string
                              cv_error TYPE string.
  DATA: lv_version TYPE so2_version, lo_error TYPE REF TO cx_root.
  FIELD-SYMBOLS <lv_value> TYPE ANY.
  CLEAR: co_page, cs_attrs, cv_name, cv_stem, cv_error.
  TRY.
      CALL METHOD cl_o2_api_pages=>load
        EXPORTING p_pagekey = ps_key p_version = 'A'
          p_langu = pv_lang p_with_all_texts = ' '
          p_load_for_generation = ' '
        IMPORTING p_page = co_page EXCEPTIONS OTHERS = 1.
      IF sy-subrc <> 0 OR co_page IS INITIAL.
        cv_error = 'Active BSP page LOAD failed'. RETURN.
      ENDIF.
      CALL METHOD co_page->get_version RECEIVING result = lv_version.
      IF lv_version <> 'A'.
        cv_error = 'BSP page API did not confirm version A'. RETURN.
      ENDIF.
      CALL METHOD co_page->get_attrs
        IMPORTING p_attrs = cs_attrs EXCEPTIONS OTHERS = 1.
      IF sy-subrc <> 0.
        cv_error = 'BSP GET_ATTRS failed'. RETURN.
      ENDIF.
      ASSIGN COMPONENT 'PAGENAME' OF STRUCTURE cs_attrs TO <lv_value>.
      IF sy-subrc = 0. cv_name = <lv_value>. ENDIF.
      IF cv_name IS INITIAL.
        ASSIGN COMPONENT 'PAGEEXT' OF STRUCTURE cs_attrs TO <lv_value>.
        IF sy-subrc = 0. cv_name = <lv_value>. ENDIF.
      ENDIF.
      IF cv_name IS INITIAL. cv_name = ps_key-pagekey. ENDIF.
      PERFORM bsp_folder USING cv_name CHANGING cv_stem cv_error.
    CATCH cx_root INTO lo_error.
      cv_error = lo_error->get_text( ).
  ENDTRY.
ENDFORM.

FORM bsp_folder_plan CHANGING ct_paths TYPE ty_bsp_paths.
  TYPES: BEGIN OF ty_count,
           name TYPE string,
           count TYPE i,
         END OF ty_count.
  DATA: lt_counts TYPE SORTED TABLE OF ty_count WITH UNIQUE KEY name,
        lt_final TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line,
        ls_count TYPE ty_count, lv_key TYPE string, lv_text TYPE string,
        lv_data TYPE xstring, lv_crc TYPE i,
        lv_hex TYPE x LENGTH 4, lv_suffix TYPE c LENGTH 8.
  FIELD-SYMBOLS: <ls_path> TYPE ty_bsp_path, <ls_count> TYPE ty_count.
* Plan every name before any page write; no first-wins or row-number suffix.
  LOOP AT ct_paths ASSIGNING <ls_path>.
    CLEAR <ls_path>-disambiguated.
    <ls_path>-folder = <ls_path>-stem.
    IF <ls_path>-error IS NOT INITIAL. CONTINUE. ENDIF.
    IF <ls_path>-stem IS INITIAL.
      gv_fatal = 'BSP folder plan contains an empty page stem'. RETURN.
    ENDIF.
    lv_key = <ls_path>-stem. TRANSLATE lv_key TO UPPER CASE.
    READ TABLE lt_counts WITH TABLE KEY name = lv_key
      ASSIGNING <ls_count>.
    IF sy-subrc = 0.
      ADD 1 TO <ls_count>-count.
    ELSE.
      ls_count-name = lv_key. ls_count-count = 1.
      INSERT ls_count INTO TABLE lt_counts.
    ENDIF.
  ENDLOOP.
  LOOP AT ct_paths ASSIGNING <ls_path>.
    IF <ls_path>-error IS NOT INITIAL. CONTINUE. ENDIF.
    lv_key = <ls_path>-stem. TRANSLATE lv_key TO UPPER CASE.
    READ TABLE lt_counts WITH TABLE KEY name = lv_key INTO ls_count.
    IF ls_count-count > 1.
* CRC32 is a stable name discriminator, not a security checksum.
* Exact PAGEKEY bytes retain case. A remaining CRC collision is rejected.
      lv_text = <ls_path>-pagekey.
      PERFORM utf8 USING lv_text CHANGING lv_data.
      CALL METHOD cl_abap_zip=>crc32
        EXPORTING content = lv_data RECEIVING crc32 = lv_crc.
      lv_hex = lv_crc. lv_suffix = lv_hex.
* ~p cannot occur in safe_leaf output (~ is escaped and ~HH is hex).
      CONCATENATE <ls_path>-stem '~p' lv_suffix INTO <ls_path>-folder.
      <ls_path>-disambiguated = 'X'.
    ENDIF.
    lv_key = <ls_path>-folder. TRANSLATE lv_key TO UPPER CASE.
    INSERT lv_key INTO TABLE lt_final.
    IF sy-subrc <> 0.
      CONCATENATE 'BSP folder identity collision; no overwrite:'
        <ls_path>-pagekey <ls_path>-folder INTO gv_fatal SEPARATED BY space.
      RETURN.
    ENDIF.
  ENDLOOP.
ENDFORM.

FORM bsp_metadata_xml USING pv_tab TYPE c ps_key TYPE o2pagkey
                            pv_lang TYPE sy-langu pv_iso TYPE c
                            pv_data TYPE ANY
                      CHANGING cv_xml TYPE xstring cv_error TYPE string.
  DATA: lv_raw TYPE xstring, lo_error TYPE REF TO cx_root.
  CLEAR: cv_xml, cv_error.
  TRY.
* Keep the entire API structure/table and original SAP field names.
* No guessed screen-label mapping, code conversion or default values.
      CASE pv_tab.
        WHEN 'P'.
          CALL TRANSFORMATION id SOURCE page_key = ps_key
            requested_language = pv_lang language_iso = pv_iso
            properties = pv_data RESULT XML lv_raw.
        WHEN 'A'.
          CALL TRANSFORMATION id SOURCE page_key = ps_key
            requested_language = pv_lang language_iso = pv_iso
            page_attributes = pv_data RESULT XML lv_raw.
        WHEN OTHERS.
          cv_error = 'Unknown BSP metadata tab'. RETURN.
      ENDCASE.
      PERFORM pretty_xml USING lv_raw CHANGING cv_xml cv_error.
      IF cv_error IS NOT INITIAL. RETURN. ENDIF.
* pretty_xml verifies every tag/leaf byte against the raw serialization.
* Do not demand an ID round-trip of arbitrary all-space STRING fields.
    CATCH cx_root INTO lo_error.
      CLEAR cv_xml.
      cv_error = lo_error->get_text( ).
  ENDTRY.
ENDFORM.

FORM test_bsp_metadata_xml USING pv_korean TYPE string.
  TYPES: BEGIN OF ty_meta,
           name TYPE c LENGTH 30, auto TYPE c LENGTH 1,
           typing TYPE c LENGTH 4, associated_type TYPE c LENGTH 30,
           description TYPE string, initial_value TYPE string,
           cache_seconds TYPE i,
         END OF ty_meta.
  DATA: ls_meta TYPE ty_meta, lt_meta TYPE STANDARD TABLE OF ty_meta,
        ls_key TYPE o2pagkey, lv_xml TYPE xstring, lv_error TYPE string,
        lv_empty TYPE string.
  ls_key-applname = 'DEVHUB_SELFTEST'. ls_key-pagekey = 'PAGE.HTM'.
  ls_meta-name = 'INIT_YN'. ls_meta-auto = 'X'.
  ls_meta-typing = 'TYPE'. ls_meta-associated_type = 'STRING'.
  CONCATENATE pv_korean '  <value>&"quotes"' gv_lf
    '  end  ' lv_empty INTO ls_meta-description RESPECTING BLANKS.
  ls_meta-initial_value = '0000123'.
  PERFORM bsp_metadata_xml USING 'P' ls_key gv_language_ko 'KO' ls_meta
    CHANGING lv_xml lv_error.
  IF lv_error IS NOT INITIAL. gv_fatal = lv_error. RETURN. ENDIF.
  APPEND ls_meta TO lt_meta.
  CLEAR: ls_meta-auto, ls_meta-description, ls_meta-initial_value.
  ls_meta-name = 'WA_TMM6003'. ls_meta-associated_type = 'ZSMM6003'.
  APPEND ls_meta TO lt_meta.
  PERFORM bsp_metadata_xml USING 'A' ls_key gv_language_ko 'KO' lt_meta
    CHANGING lv_xml lv_error.
  IF lv_error IS NOT INITIAL. gv_fatal = lv_error. RETURN. ENDIF.
  REFRESH lt_meta.
  PERFORM bsp_metadata_xml USING 'A' ls_key gv_language_ko 'KO' lt_meta
    CHANGING lv_xml lv_error.
  IF lv_error IS NOT INITIAL. gv_fatal = lv_error. ENDIF.
ENDFORM.

FORM bsp_event_field CHANGING cv_field TYPE string cv_error TYPE string.
  STATICS: sv_checked TYPE c LENGTH 1, sv_field TYPE string,
           sv_error TYPE string.
  DATA: lt_fields TYPE STANDARD TABLE OF dd03l-fieldname,
        lv_field TYPE dd03l-fieldname, lv_count TYPE i.
* O2EVHANDLR is evidenced by GET_EVENT_HANDLER-P_NAME in KSD/300.
* Resolve its active DDIC field; do not guess a component or row order.
  IF sv_checked IS INITIAL.
    sv_checked = 'X'.
    SELECT fieldname INTO TABLE lt_fields FROM dd03l
      WHERE tabname = 'O2PAGEVH' AND as4local = 'A'
        AND as4vers = '0000' AND rollname = 'O2EVHANDLR'.
    DESCRIBE TABLE lt_fields LINES lv_count.
    IF lv_count = 1.
      READ TABLE lt_fields INDEX 1 INTO lv_field.
      sv_field = lv_field.
    ELSE.
      sv_error = 'BSP O2PAGEVH event identity is not unique in active DDIC (O2EVHANDLR)'.
    ENDIF.
  ENDIF.
  cv_field = sv_field. cv_error = sv_error.
ENDFORM.

FORM bsp_event_name USING ps_event TYPE ANY pv_field TYPE string
                    CHANGING cv_name TYPE string cv_error TYPE string.
  DATA: lv_id TYPE string, lv_key TYPE string, lv_kind TYPE c.
  FIELD-SYMBOLS <lv_id> TYPE ANY.
  CLEAR: cv_name, cv_error.
  ASSIGN COMPONENT pv_field OF STRUCTURE ps_event TO <lv_id>.
  IF sy-subrc <> 0.
    cv_error = 'BSP event identity component missing from API row'. RETURN.
  ENDIF.
  DESCRIBE FIELD <lv_id> TYPE lv_kind.
  IF lv_kind <> 'C' AND lv_kind <> 'g'.
    cv_error = 'BSP event identity is not character data'. RETURN.
  ENDIF.
  lv_id = <lv_id>.
  IF lv_id IS INITIAL.
    cv_error = 'BSP event identity is empty; no numbered fallback'. RETURN.
  ENDIF.
  lv_key = lv_id. TRANSLATE lv_key TO UPPER CASE.
  CASE lv_key.
    WHEN 'ONCREATE'. cv_name = 'OnCreate'.
    WHEN 'ONREQUEST'. cv_name = 'OnRequest'.
    WHEN 'ONINITIALIZATION'. cv_name = 'OnInitialization'.
    WHEN 'ONMANIPULATION'. cv_name = 'OnManipulation'.
    WHEN 'ONINPUTPROCESSING'. cv_name = 'OnInputProcessing'.
    WHEN 'ONDESTROY'. cv_name = 'OnDestroy'.
    WHEN OTHERS.
* Preserve any other actual handler identity; never assign a guessed slot.
      PERFORM safe_leaf USING lv_id CHANGING cv_name.
  ENDCASE.
ENDFORM.

FORM bsp_events USING pt_events TYPE ANY TABLE pv_field TYPE string
                      pv_dir TYPE string
                 CHANGING cv_error TYPE string.
  TYPES: BEGIN OF ty_event_file,
           name TYPE string, text TYPE string,
         END OF ty_event_file.
  DATA: lt_files TYPE STANDARD TABLE OF ty_event_file,
        ls_file TYPE ty_event_file, lv_key TYPE string,
        lt_seen TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line,
        lv_path TYPE string, lv_ok TYPE c LENGTH 1.
  FIELD-SYMBOLS: <ls_event> TYPE ANY, <lt_source> TYPE ANY TABLE.
  CLEAR cv_error.
* Validate every identity before writing any event source for this page.
* O2PAGEVH_TABLETYPE is sorted: no SORT and no positional mapping.
  LOOP AT pt_events ASSIGNING <ls_event>.
    CLEAR ls_file.
    PERFORM bsp_event_name USING <ls_event> pv_field
      CHANGING ls_file-name cv_error.
    IF cv_error IS NOT INITIAL. RETURN. ENDIF.
    lv_key = ls_file-name. TRANSLATE lv_key TO UPPER CASE.
    INSERT lv_key INTO TABLE lt_seen.
    IF sy-subrc <> 0.
      CONCATENATE 'BSP duplicate/case-colliding event identity:'
        ls_file-name INTO cv_error SEPARATED BY space. RETURN.
    ENDIF.
    ASSIGN COMPONENT 'SOURCE' OF STRUCTURE <ls_event> TO <lt_source>.
    IF sy-subrc <> 0.
      cv_error = 'BSP event SOURCE table missing'. RETURN.
    ENDIF.
    PERFORM web_lines USING <lt_source> CHANGING ls_file-text lv_ok.
    IF lv_ok IS INITIAL.
      cv_error = 'BSP event source row unsupported'. RETURN.
    ENDIF.
    APPEND ls_file TO lt_files.
  ENDLOOP.
  LOOP AT lt_files INTO ls_file.
    CONCATENATE pv_dir 'Event Handler/' ls_file-name '.abap'
      INTO lv_path.
    PERFORM add_text USING lv_path 'BSP_EVENT_SOURCE' ls_file-text.
    IF gv_fatal IS NOT INITIAL. cv_error = gv_fatal. RETURN. ENDIF.
  ENDLOOP.
ENDFORM.

FORM bsp_page USING ps_key TYPE o2pagkey pv_lang TYPE sy-langu
                    pv_iso TYPE c ps_path TYPE ty_bsp_path
              CHANGING cv_ok TYPE c.
  DATA: lo_page TYPE REF TO cl_o2_api_pages,
        ls_attrs TYPE o2pagattr, lt_content TYPE o2pageline_table,
        lt_events TYPE o2pagevh_tabletype,
        lt_params TYPE o2pagpar_tabletype, lt_types TYPE rswsourcet,
        lv_layout TYPE xstring, lt_guids TYPE bsp_guids,
        lv_again TYPE xstring, lt_again TYPE o2pageline_table,
        lv_xml TYPE xstring, lv_event_field TYPE string,
        lv_text TYPE string, lv_name TYPE string, lv_leaf TYPE string,
        lv_path TYPE string, lv_dir TYPE string, lv_folder TYPE string,
        lv_type TYPE c LENGTH 1, lv_ok TYPE c LENGTH 1,
        lv_error TYPE string, lv_rc TYPE sy-subrc,
        ls_asset TYPE ty_web_asset, lo_error TYPE REF TO cx_root.
  FIELD-SYMBOLS <lv_value> TYPE ANY.
  CLEAR cv_ok.
  PERFORM web_init CHANGING ls_asset.
  ls_asset-kind = 'BSP_PAGE'.
  ls_asset-language = pv_lang.
  ls_asset-requested_language = gv_language_ko.
  ls_asset-component = ps_key-pagekey.
  ls_asset-original_path = ps_key-pagekey.
  gv_component = ps_key-pagekey.
  gv_stage = 'BSP_PAGE'.
  gv_file_language = pv_lang.
  gv_payload_state = 'A'.
  lv_error = ps_path-error.
  TRY.
      IF lv_error IS INITIAL.
        PERFORM bsp_read_header USING ps_key pv_lang
          CHANGING lo_page ls_attrs lv_name lv_folder lv_error.
      ENDIF.
      IF lv_error IS INITIAL.
        ls_asset-original_path = lv_name.
        IF ps_path-pagekey <> ps_key-pagekey OR
           ps_path-original_name <> lv_name OR ps_path-folder IS INITIAL.
          lv_error = 'BSP page name changed after path planning; export again'.
        ELSE.
          lv_folder = ps_path-folder.
        ENDIF.
      ENDIF.
      IF lv_error IS INITIAL.
        CONCATENATE 'pages/' lv_folder '/' INTO lv_dir.
        PERFORM bsp_metadata_xml USING 'P' ps_key pv_lang pv_iso ls_attrs
          CHANGING lv_xml lv_error.
        IF lv_error IS INITIAL.
          CONCATENATE lv_dir 'Properties.xml' INTO lv_path.
          PERFORM add_file USING lv_path 'BSP_ATTRIBUTES' lv_xml.
          CONCATENATE gv_root lv_path INTO ls_asset-metadata_path.
        ENDIF.
        IF gv_fatal IS NOT INITIAL.
* Keep the final archive collision guard even after path planning.
          lv_error = gv_fatal.
        ENDIF.
      ENDIF.
      IF lv_error IS INITIAL.
        ASSIGN COMPONENT 'PAGETYPE' OF STRUCTURE ls_attrs TO <lv_value>.
        IF sy-subrc = 0. lv_type = <lv_value>. ENDIF.
* Original class attributes remain in Properties.xml; no class traversal.
        IF lv_type = 'C'.
          ls_asset-kind = 'BSP_CONTROLLER'.
          ls_asset-status = 'REFERENCE_ONLY'.
          ls_asset-detail = 'Controller attributes saved; class is a reference'.
        ELSE.
          CALL METHOD lo_page->get_page
            IMPORTING p_content = lt_content p_xml_source = lv_layout
              p_otr_guids = lt_guids EXCEPTIONS OTHERS = 1.
          lv_rc = sy-subrc.
          IF lv_rc = 0.
            CALL METHOD lo_page->get_page
              IMPORTING p_content = lt_again p_xml_source = lv_again
              EXCEPTIONS OTHERS = 1.
            lv_rc = sy-subrc.
          ENDIF.
          IF lv_rc <> 0 OR lt_content <> lt_again OR lv_layout <> lv_again.
            lv_error = 'BSP GET_PAGE failed or content changed between reads'.
          ELSE.
            IF lv_layout IS INITIAL AND lt_content IS NOT INITIAL.
* Do not mistake legacy binary/hex MIME page rows for text.
              IF lv_type = 'H' OR lv_type = 'V' OR lv_type = 'F'.
                PERFORM web_lines USING lt_content
                  CHANGING lv_text lv_ok.
                IF lv_ok = 'X'.
                  PERFORM utf8 USING lv_text CHANGING lv_layout.
                ELSE.
                  lv_error = 'BSP layout row type unsupported; layout not exported'.
                ENDIF.
              ELSE.
                lv_error = 'BSP layout has rows but no XML bytes; ambiguous binary layout not exported'.
              ENDIF.
            ENDIF.
            IF lv_error IS INITIAL.
              lv_name = ls_asset-original_path.
              PERFORM web_leaf USING lv_name CHANGING lv_leaf.
              CONCATENATE lv_dir 'Layout/' lv_leaf INTO lv_path.
              PERFORM web_blob USING lv_path 'BSP_LAYOUT' lv_layout.
              CONCATENATE gv_root lv_path INTO ls_asset-content_path.
              ls_asset-byte_length = xstrlen( lv_layout ).
              ls_asset-active_state = 'A'.
            ENDIF.
          ENDIF.
          IF lv_error IS INITIAL.
            CALL METHOD lo_page->get_event_handlers
              IMPORTING p_ev_handler = lt_events EXCEPTIONS OTHERS = 1.
            IF sy-subrc <> 0. lv_error = 'BSP GET_EVENT_HANDLERS failed'. ENDIF.
          ENDIF.
          IF lv_error IS INITIAL.
            IF lt_events IS NOT INITIAL.
              PERFORM bsp_event_field CHANGING lv_event_field lv_error.
              IF lv_error IS INITIAL.
                PERFORM bsp_events USING lt_events lv_event_field lv_dir
                  CHANGING lv_error.
              ENDIF.
            ENDIF.
          ENDIF.
          IF lv_error IS INITIAL.
            CALL METHOD lo_page->get_parameters
              IMPORTING p_parameters = lt_params EXCEPTIONS OTHERS = 1.
            IF sy-subrc <> 0. lv_error = 'BSP GET_PARAMETERS failed'. ENDIF.
          ENDIF.
          IF lv_error IS INITIAL.
            PERFORM bsp_metadata_xml USING 'A' ps_key pv_lang pv_iso
              lt_params CHANGING lv_xml lv_error.
            IF lv_error IS INITIAL.
              CONCATENATE lv_dir 'Page Attributes.xml' INTO lv_path.
              PERFORM add_file USING lv_path 'BSP_PARAMETERS' lv_xml.
            ENDIF.
          ENDIF.
          IF lv_error IS INITIAL.
            CALL METHOD lo_page->get_type_source
              IMPORTING p_source = lt_types EXCEPTIONS OTHERS = 1.
            IF sy-subrc <> 0. lv_error = 'BSP GET_TYPE_SOURCE failed'. ENDIF.
          ENDIF.
          IF lv_error IS INITIAL.
            PERFORM web_lines USING lt_types CHANGING lv_text lv_ok.
            IF lv_ok = 'X'.
              CONCATENATE lv_dir 'Type Definitions.abap' INTO lv_path.
              PERFORM add_text USING lv_path 'BSP_TYPE_SOURCE' lv_text.
              ls_asset-status = 'EXPORTED'.
              ls_asset-detail = 'Active BSP tabs read; events named by DDIC identity; dependency coverage partial'.
            ELSE.
              lv_error = 'BSP type source row unsupported; type definitions not exported'.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    CATCH cx_root INTO lo_error.
      lv_error = lo_error->get_text( ).
  ENDTRY.
  IF lv_error IS INITIAL AND gv_fatal IS NOT INITIAL.
    lv_error = gv_fatal.
  ENDIF.
  IF lv_error IS NOT INITIAL.
    ls_asset-status = 'FAILED'. ls_asset-detail = lv_error.
    PERFORM web_fail USING lv_error.
  ELSE.
    cv_ok = 'X'.
  ENDIF.
  APPEND ls_asset TO gt_web_assets.
  CLEAR: gv_payload_state, gv_file_language, gv_check_mode.
ENDFORM.

FORM export_bsp.
  DATA: lo_app TYPE REF TO cl_o2_api_application,
        lo_page TYPE REF TO cl_o2_api_pages, ls_page_attrs TYPE o2pagattr,
        lt_keys TYPE ty_bsp_keys, lt_paths TYPE ty_bsp_paths,
        ls_path TYPE ty_bsp_path,
        ls_attrs TYPE o2applattr, lt_pages TYPE o2pagelist,
        ls_key TYPE o2pagkey, lv_app TYPE o2applname,
        lv_xml TYPE xstring, lv_lang TYPE sy-langu,
        lv_iso TYPE c LENGTH 2, lv_path TYPE string,
        lv_done TYPE i, lv_failed TYPE i,
        lv_ok TYPE c LENGTH 1, lv_error TYPE string,
        lv_n1 TYPE c LENGTH 12, lv_n2 TYPE c LENGTH 12,
        lo_error TYPE REF TO cx_root.
  gv_stage = 'BSP_APPLICATION'.
  lv_app = gs_object-obj_name.
  IF lv_app <> gs_object-obj_name.
    PERFORM web_fail USING 'BSP application name exceeds API field length'.
    RETURN.
  ENDIF.
  TRY.
      CALL METHOD cl_o2_api_application=>load
        EXPORTING p_application_name = lv_app
        IMPORTING p_application = lo_app EXCEPTIONS OTHERS = 1.
      IF sy-subrc <> 0 OR lo_app IS INITIAL.
        PERFORM web_fail USING 'BSP application LOAD failed'. RETURN.
      ENDIF.
      CALL METHOD lo_app->get_attributes EXPORTING p_version = 'A'
        IMPORTING p_attributes = ls_attrs EXCEPTIONS OTHERS = 1.
      IF sy-subrc <> 0 OR ls_attrs IS INITIAL.
        PERFORM web_fail USING 'Active BSP application attributes unavailable'.
        RETURN.
      ENDIF.
      gv_payload_state = 'A'.
* Application class references are not read or logged by policy.
* MIME repository traversal checks ownership before reading any body.
      PERFORM export_bsp_mimes USING lv_app.
      IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
      DO 1 TIMES.
        PERFORM korean_language CHANGING lv_lang lv_iso.
        REFRESH lt_pages.
        CALL METHOD cl_o2_api_pages=>get_all_pages
          EXPORTING p_applname = lv_app p_version = 'A'
            p_with_texts = 'X' p_mod_langu = lv_lang
          IMPORTING p_pages = lt_pages EXCEPTIONS OTHERS = 1.
        IF ( sy-subrc <> 0 OR lt_pages IS INITIAL )
           AND gv_language_en IS NOT INITIAL.
          PERFORM log USING 'LANGUAGE_RETRY' 'INFO'
            'KO BSP inventory absent; retrying active inventory in EN'.
          REFRESH lt_pages. lv_lang = gv_language_en. lv_iso = 'EN'.
          CALL METHOD cl_o2_api_pages=>get_all_pages
            EXPORTING p_applname = lv_app p_version = 'A'
              p_with_texts = 'X' p_mod_langu = lv_lang
            IMPORTING p_pages = lt_pages EXCEPTIONS OTHERS = 1.
        ENDIF.
        IF sy-subrc <> 0.
          PERFORM web_fail USING 'Active BSP page inventory read failed'.
          CONTINUE.
        ENDIF.
        gv_payload_state = 'A'. gv_file_language = lv_lang.
* O2PAGELIST is sorted; retain its primary-key order.
        CALL TRANSFORMATION id SOURCE pages = lt_pages
          requested_language = lv_lang RESULT XML lv_xml.
        lv_path = 'pages/pages.xml'.
        PERFORM add_file USING lv_path 'BSP_PAGE_INVENTORY' lv_xml.
        IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
        PERFORM bsp_inventory_keys USING lt_pages lv_app
          CHANGING lt_keys lv_failed.
        REFRESH lt_paths.
        LOOP AT lt_keys INTO ls_key.
          CLEAR ls_path. ls_path-pagekey = ls_key-pagekey.
          PERFORM korean_language
            CHANGING ls_path-read_language ls_path-read_iso.
          PERFORM bsp_read_header USING ls_key ls_path-read_language
            CHANGING lo_page ls_page_attrs ls_path-original_name
              ls_path-stem ls_path-error.
          IF ls_path-error = 'Active BSP page LOAD failed'
             AND gv_language_en IS NOT INITIAL.
            ls_path-read_language = gv_language_en. ls_path-read_iso = 'EN'.
            PERFORM bsp_read_header USING ls_key ls_path-read_language
              CHANGING lo_page ls_page_attrs ls_path-original_name
                ls_path-stem ls_path-error.
            IF ls_path-error IS INITIAL.
              gv_component = ls_key-pagekey.
              PERFORM log USING 'LANGUAGE_FALLBACK' 'INFO'
                'Active BSP page LOAD succeeded in EN after KO failed'.
            ENDIF.
          ENDIF.
          APPEND ls_path TO lt_paths.
          CLEAR lo_page.
          IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
        ENDLOOP.
        PERFORM bsp_folder_plan CHANGING lt_paths.
        IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
        CALL TRANSFORMATION id SOURCE application = lv_app
          requested_language = lv_lang page_paths = lt_paths
          RESULT XML lv_xml.
        lv_path = 'pages/page-paths.xml'.
* Per-page read languages are in the map; it may contain both KO and EN.
        CLEAR gv_file_language.
        PERFORM add_file USING lv_path 'BSP_PAGE_PATH_MAP' lv_xml.
        IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
        LOOP AT lt_paths INTO ls_path.
          CLEAR ls_key. ls_key-applname = lv_app.
          ls_key-pagekey = ls_path-pagekey.
          gv_component = ls_key-pagekey.
          IF ls_path-disambiguated = 'X'.
            CONCATENATE 'Page folder disambiguated:' ls_path-pagekey
              '->' ls_path-folder INTO lv_error SEPARATED BY space.
            PERFORM log USING 'BSP_PAGE_PATH' 'INFO' lv_error.
          ENDIF.
          PERFORM bsp_page USING ls_key ls_path-read_language
            ls_path-read_iso ls_path
            CHANGING lv_ok.
          IF lv_ok = 'X'. ADD 1 TO lv_done.
          ELSE. ADD 1 TO lv_failed. ENDIF.
          IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
        ENDLOOP.
      ENDDO.
    CATCH cx_root INTO lo_error.
      lv_error = lo_error->get_text( ).
      PERFORM web_fail USING lv_error.
  ENDTRY.
  WRITE lv_done TO lv_n1. CONDENSE lv_n1.
  WRITE lv_failed TO lv_n2. CONDENSE lv_n2.
  CONCATENATE 'BSP page/language reads completed=' lv_n1
    '; failed=' lv_n2 '; controller classes remain references'
    INTO lv_error.
  gv_component = gs_object-obj_name.
  PERFORM log USING 'BSP_SUMMARY' 'INFO' lv_error.
  IF gs_object-status <> 'FAILED'.
    gs_object-reason = 'BSP active pages/events and metadata; classes/OTR/dynamic dependencies partial'.
  ENDIF.
  CLEAR: gv_payload_state, gv_file_language.
ENDFORM.

FORM bsp_app_from_url USING pv_url TYPE string
                     CHANGING cv_app TYPE string cv_bsp TYPE c
                              cv_valid TYPE c.
  DATA: lv_url TYPE string, lv_tail TYPE string,
        lt_parts TYPE ty_lines, lv_namespace TYPE string,
        lv_name TYPE string, lv_api_name TYPE o2applname.
  CLEAR: cv_app, cv_bsp, cv_valid.
  lv_url = pv_url.
  TRANSLATE lv_url TO UPPER CASE.
  IF lv_url NP '/SAP/BC/BSP/*'.
* A noncanonical BSP path must not silently pass the scope check.
    IF lv_url CP '*/SAP/BC/BSP/*'. cv_bsp = 'X'. ENDIF.
    RETURN.
  ENDIF.
  cv_bsp = 'X'.
  lv_tail = lv_url+12.
  SPLIT lv_tail AT '/' INTO TABLE lt_parts.
  READ TABLE lt_parts INTO lv_namespace INDEX 1.
  READ TABLE lt_parts INTO lv_name INDEX 2.
  IF lv_namespace IS INITIAL OR lv_name IS INITIAL.
    RETURN.
  ENDIF.
* Resolve canonical, unescaped names only. Never guess encoded aliases.
  IF lv_namespace CN 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_' OR
     lv_name CN 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_'.
    RETURN.
  ENDIF.
  IF lv_namespace = 'SAP'.
    cv_app = lv_name.
  ELSE.
    CONCATENATE '/' lv_namespace '/' lv_name INTO cv_app.
  ENDIF.
  lv_api_name = cv_app.
  IF lv_api_name <> cv_app.
    CLEAR cv_app. RETURN.
  ENDIF.
  cv_valid = 'X'.
ENDFORM.

FORM smim_bsp_scope USING pv_url TYPE string
                    CHANGING cv_read TYPE c.
  DATA: lv_app TYPE string, lv_bsp TYPE c LENGTH 1,
        lv_valid TYPE c LENGTH 1, lv_name TYPE tadir-obj_name,
        lv_package TYPE tadir-devclass, ls_ref TYPE ty_web_ref.
  cv_read = 'X'.
  PERFORM bsp_app_from_url USING pv_url
    CHANGING lv_app lv_bsp lv_valid.
  IF lv_bsp IS INITIAL. RETURN. ENDIF.
  CLEAR cv_read.
  ls_ref-object = gs_object-object.
  ls_ref-obj_name = gs_object-obj_name.
  ls_ref-component = pv_url.
  ls_ref-target_object = 'WAPA'.
  ls_ref-target_name = lv_app.
  ls_ref-evidence = 'SMIM_URL_BSP_APP_TADIR'.
  IF lv_valid = 'X'.
    lv_name = lv_app.
    SELECT SINGLE devclass FROM tadir INTO lv_package
      WHERE pgmid = 'R3TR' AND object = 'WAPA' AND obj_name = lv_name.
    IF sy-subrc <> 0. CLEAR lv_package. ENDIF.
  ENDIF.
  IF lv_package IS NOT INITIAL.
    READ TABLE gt_seen_pkg WITH TABLE KEY devclass = lv_package
      TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      cv_read = 'X'. RETURN.
    ENDIF.
* The SMIM registration can be in scope while its BSP app is outside.
* Exclude before the KO content read. Record only the external reference.
    ls_ref-target_package = lv_package.
    ls_ref-scope = 'EXTERNAL_REFERENCE_ONLY'.
    gs_object-status = 'EXCLUDED'.
    CONCATENATE 'BSP application' lv_app 'belongs to unselected package'
      lv_package '; MIME content excluded; reference only'
      INTO gs_object-reason SEPARATED BY space.
  ELSE.
* Unverified ownership is not proof of an external package or success.
    ls_ref-scope = 'OWNER_UNRESOLVED'.
    gs_object-status = 'PARTIAL'.
    gs_object-reason =
      'BSP application package unresolved; MIME content not read'.
    PERFORM log USING 'MIME_SCOPE' 'UNRESOLVED' gs_object-reason.
  ENDIF.
  APPEND ls_ref TO gt_web_refs.
ENDFORM.

FORM export_smim.
  DATA: lo_mime TYPE REF TO if_mr_api, lv_id TYPE sdok_docid,
        lv_url TYPE string, lv_folder TYPE boole_d,
        lv_folder2 TYPE boole_d, lv_data TYPE xstring,
        lv_again TYPE xstring, lv_mime TYPE string,
        lv_mime2 TYPE string, lv_lang TYPE sy-langu,
        lv_actual TYPE langu, lv_actual2 TYPE langu,
        lv_iso TYPE c LENGTH 2, lv_phio TYPE sdok_phid,
        lv_phio2 TYPE sdok_phid, lv_path TYPE string,
        lv_content_root TYPE string, lv_content_path TYPE string,
        lv_saved_root TYPE string,
        lv_scope_read TYPE c LENGTH 1,
        lv_error TYPE string, ls_asset TYPE ty_web_asset,
        lo_error TYPE REF TO cx_root.
  gv_stage = 'MIME_READ'.
  lv_id = gs_object-obj_name.
  IF lv_id <> gs_object-obj_name OR lv_id IS INITIAL.
    PERFORM web_fail USING 'SMIM LOIO identifier cannot be represented'. RETURN.
  ENDIF.
  TRY.
      lo_mime = cl_mime_repository_api=>get_api( ).
      IF lo_mime IS INITIAL.
        PERFORM web_fail USING 'MIME repository API unavailable'. RETURN.
      ENDIF.
      CALL METHOD lo_mime->get_url_for_io EXPORTING i_loio = lv_id
        IMPORTING e_url = lv_url e_is_folder = lv_folder
        EXCEPTIONS OTHERS = 1.
      IF sy-subrc <> 0 OR lv_url IS INITIAL.
        PERFORM skip_object USING 'MIME_URL'
          'MIME omitted: URL unavailable for registered LOIO'.
        RETURN.
      ENDIF.
      PERFORM smim_bsp_scope USING lv_url CHANGING lv_scope_read.
      IF lv_scope_read IS INITIAL. RETURN. ENDIF.
      lv_saved_root = gv_root.
      IF lv_folder = 'X'.
        PERFORM web_init CHANGING ls_asset.
        ls_asset-kind = 'MIME_FOLDER'. ls_asset-status = 'FOLDER'.
        ls_asset-component = lv_id. ls_asset-original_path = lv_url.
        ls_asset-active_state = 'U'.
        ls_asset-detail = 'Folder metadata; child files follow package TADIR selection'.
        PERFORM mime_metadata_path USING gs_object-devclass
          CHANGING ls_asset-metadata_path.
        CLEAR lv_phio.
        PERFORM mime_metadata_add USING ls_asset lv_id lv_phio lv_folder.
        APPEND ls_asset TO gt_web_assets.
      ELSE.
        DO 1 TIMES.
          PERFORM korean_language CHANGING lv_lang lv_iso.
          PERFORM web_init CHANGING ls_asset.
          ls_asset-kind = 'MIME_FILE'. ls_asset-component = lv_id.
          ls_asset-original_path = lv_url.
          ls_asset-requested_language = lv_lang.
          CLEAR: lv_data, lv_again, lv_error, lv_mime, lv_mime2,
                 lv_phio, lv_phio2, lv_folder2.
          lv_actual = lv_lang. lv_actual2 = lv_lang.
          CALL METHOD lo_mime->get_by_io
            EXPORTING i_loio = lv_id i_check_authority = 'X'
            IMPORTING e_content = lv_data e_mime_type = lv_mime
              e_is_folder = lv_folder2 e_phio_id = lv_phio
            CHANGING c_language = lv_actual EXCEPTIONS OTHERS = 1.
          IF sy-subrc <> 0 AND gv_language_en IS NOT INITIAL.
* Same LOIO and checked package only. Do not retry a byte/identity mismatch.
            PERFORM log USING 'LANGUAGE_RETRY' 'INFO'
              'KO MIME read failed; retrying the same LOIO in EN'.
            CLEAR: lv_data, lv_mime, lv_phio, lv_folder2.
            lv_actual = gv_language_en. lv_actual2 = gv_language_en.
            CALL METHOD lo_mime->get_by_io
              EXPORTING i_loio = lv_id i_check_authority = 'X'
              IMPORTING e_content = lv_data e_mime_type = lv_mime
                e_is_folder = lv_folder2 e_phio_id = lv_phio
              CHANGING c_language = lv_actual EXCEPTIONS OTHERS = 1.
          ENDIF.
          IF sy-subrc <> 0 OR lv_folder2 = 'X'.
            lv_error = 'MIME GET_BY_IO failed or changed to folder'.
          ELSE.
            CALL METHOD lo_mime->get_by_io
              EXPORTING i_loio = lv_id i_check_authority = 'X'
              IMPORTING e_content = lv_again e_mime_type = lv_mime2
                e_is_folder = lv_folder2 e_phio_id = lv_phio2
              CHANGING c_language = lv_actual2 EXCEPTIONS OTHERS = 1.
            IF sy-subrc <> 0 OR lv_folder2 = 'X' OR lv_data <> lv_again
              OR lv_actual <> lv_actual2 OR lv_phio <> lv_phio2
              OR lv_mime <> lv_mime2.
              lv_error = 'MIME content/language/identity changed between reads'.
            ENDIF.
          ENDIF.
          IF lv_error IS INITIAL.
            PERFORM mime_language_policy USING lv_actual
              CHANGING lv_error.
          ENDIF.
          IF lv_error IS INITIAL.
* MIME_TYPE is known only after the repository bytes have been read.
            PERFORM mime_output_path USING lv_url lv_folder lv_mime
              CHANGING lv_content_root lv_content_path lv_error.
          ENDIF.
          IF lv_error IS INITIAL.
            gv_payload_state = 'U'. gv_file_language = lv_actual.
            gv_root = lv_content_root.
            PERFORM web_blob USING lv_content_path 'MIME_CONTENT' lv_data.
            CONCATENATE gv_root lv_content_path
              INTO ls_asset-content_path.
            gv_root = lv_saved_root.
            IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
            ls_asset-status = 'EXPORTED'. ls_asset-language = lv_actual.
            ls_asset-mime_type = lv_mime.
            ls_asset-byte_length = xstrlen( lv_data ).
            ls_asset-active_state = 'U'.
            ls_asset-detail = 'Raw bytes; API version unverified; actual language recorded'.
            PERFORM mime_metadata_path USING gs_object-devclass
              CHANGING ls_asset-metadata_path.
            PERFORM mime_metadata_add USING ls_asset lv_id lv_phio lv_folder.
            IF lv_actual IS INITIAL.
              PERFORM log USING 'MIME_LANGUAGE' 'INFO'
                'Language-neutral MIME content; actual key is blank'.
            ELSEIF lv_actual = gv_language_en.
              PERFORM log USING 'LANGUAGE_FALLBACK' 'INFO'
                'MIME returned EN for the same LOIO; raw bytes preserved'.
            ENDIF.
          ELSE.
            ls_asset-detail = lv_error.
            PERFORM web_fail USING lv_error.
          ENDIF.
          APPEND ls_asset TO gt_web_assets.
          IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
        ENDDO.
      ENDIF.
    CATCH cx_root INTO lo_error.
      lv_error = lo_error->get_text( ). PERFORM web_fail USING lv_error.
  ENDTRY.
  IF gs_object-status <> 'FAILED'.
    gs_object-reason = 'MIME raw content/folder metadata read; active version unverified'.
  ENDIF.
  CLEAR: gv_payload_state, gv_file_language, gv_check_mode.
ENDFORM.


FORM mime_language_policy USING pv_actual TYPE sy-langu
                         CHANGING cv_error TYPE string.
  CLEAR cv_error.
  IF pv_actual IS NOT INITIAL AND pv_actual <> gv_language_ko
     AND pv_actual <> gv_language_en.
    cv_error = 'MIME returned a language outside KO/EN/neutral; content excluded'.
  ENDIF.
ENDFORM.

FORM web_binary USING pt_rows TYPE ANY TABLE pv_size TYPE i
                CHANGING cv_data TYPE xstring cv_ok TYPE c.
  DATA: lv_kind TYPE c, lv_chunk TYPE xstring, lv_left TYPE i,
        lv_take TYPE i, lv_len TYPE i.
  FIELD-SYMBOLS: <ls_row> TYPE ANY, <lv_value> TYPE ANY,
                 <lv_extra> TYPE ANY.
  CLEAR: cv_data, cv_ok. lv_left = pv_size.
  IF pv_size < 0 OR pv_size > 16777216. RETURN. ENDIF.
  LOOP AT pt_rows ASSIGNING <ls_row>.
    IF lv_left <= 0. RETURN. ENDIF.
    DESCRIBE FIELD <ls_row> TYPE lv_kind.
    IF lv_kind = 'u' OR lv_kind = 'v'.
      ASSIGN COMPONENT 1 OF STRUCTURE <ls_row> TO <lv_value>.
      IF sy-subrc <> 0. RETURN. ENDIF.
      ASSIGN COMPONENT 2 OF STRUCTURE <ls_row> TO <lv_extra>.
      IF sy-subrc = 0. RETURN. ENDIF.
    ELSE.
      ASSIGN <ls_row> TO <lv_value>.
    ENDIF.
    DESCRIBE FIELD <lv_value> TYPE lv_kind.
    IF lv_kind <> 'X' AND lv_kind <> 'y'. RETURN. ENDIF.
    lv_chunk = <lv_value>. lv_len = xstrlen( lv_chunk ).
    lv_take = lv_len.
    IF lv_take > lv_left. lv_take = lv_left. ENDIF.
    CONCATENATE cv_data lv_chunk(lv_take) INTO cv_data IN BYTE MODE.
    SUBTRACT lv_take FROM lv_left.
  ENDLOOP.
  IF lv_left = 0. cv_ok = 'X'. ENDIF.
ENDFORM.

FORM export_w3mi.
  DATA: lt_meta TYPE STANDARD TABLE OF fupararef, ls_meta TYPE fupararef,
        lr_key TYPE REF TO data, lr_mime TYPE REF TO data,
        lr_again TYPE REF TO data, lr_params TYPE REF TO data,
        lr_params2 TYPE REF TO data, lv_type TYPE string,
        lv_table TYPE c LENGTH 30, lv_where TYPE string,
        lv_id TYPE c LENGTH 40, lv_relid TYPE c LENGTH 2,
        lv_fname TYPE string, lv_ext TYPE string, lv_mime TYPE string,
        lv_size_text TYPE string, lv_size TYPE i, lv_xml TYPE xstring,
        lv_data TYPE xstring, lv_ok TYPE c LENGTH 1,
        lv_key_ok TYPE c LENGTH 1, lv_mime_ok TYPE c LENGTH 1,
        lv_fm TYPE rs38l-name, lv_name TYPE string, lv_value TYPE string,
        lv_leaf TYPE string, lv_path TYPE string, lv_error TYPE string,
        ls_asset TYPE ty_web_asset, lo_error TYPE REF TO cx_root.
  FIELD-SYMBOLS: <ls_key> TYPE ANY, <lt_mime> TYPE STANDARD TABLE,
                 <lt_again> TYPE STANDARD TABLE,
                 <lt_params> TYPE STANDARD TABLE,
                 <lt_params2> TYPE STANDARD TABLE,
                 <ls_param> TYPE ANY, <lv_field> TYPE ANY.
  gv_stage = 'W3MI_READ'.
  PERFORM web_init CHANGING ls_asset.
  ls_asset-kind = 'WEB_MIME_FILE'.
  ls_asset-component = gs_object-obj_name.
  lv_id = gs_object-obj_name. lv_relid = 'MI'.
  lv_fm = 'WWWDATA_IMPORT'.
  TRY.
* This function reads repository bytes into memory. It does not import
* or save anything to the Repository. Verify its active bindings first.
      SELECT * FROM fupararef INTO TABLE lt_meta
        WHERE funcname = lv_fm AND r3state = 'A'.
      LOOP AT lt_meta INTO ls_meta.
        IF ls_meta-paramtype = 'I' AND ls_meta-parameter = 'KEY'
          AND ls_meta-structure = 'WWWDATATAB'.
          lv_key_ok = 'X'.
        ELSEIF ls_meta-paramtype = 'T' AND ls_meta-parameter = 'MIME'
          AND ls_meta-structure = 'W3MIME'.
          lv_mime_ok = 'X'.
        ELSEIF ( ls_meta-paramtype = 'I' OR ls_meta-paramtype = 'C'
          OR ls_meta-paramtype = 'T' ) AND ls_meta-optional IS INITIAL
          AND ls_meta-defaultval IS INITIAL.
          lv_error = 'WWWDATA_IMPORT has another required binding'.
        ENDIF.
      ENDLOOP.
      IF lv_key_ok IS INITIAL OR lv_mime_ok IS INITIAL.
        lv_error = 'WWWDATA_IMPORT KEY/MIME active interface differs'.
      ENDIF.
      IF lv_id <> gs_object-obj_name.
        lv_error = 'W3MI name exceeds key length'.
      ENDIF.
      IF lv_error IS INITIAL.
        lv_type = 'WWWDATATAB'. CREATE DATA lr_key TYPE (lv_type).
        ASSIGN lr_key->* TO <ls_key>.
        ASSIGN COMPONENT 'RELID' OF STRUCTURE <ls_key> TO <lv_field>.
        IF sy-subrc <> 0.
          lv_error = 'WWWDATATAB RELID missing'.
        ELSE.
          <lv_field> = lv_relid.
        ENDIF.
        ASSIGN COMPONENT 'OBJID' OF STRUCTURE <ls_key> TO <lv_field>.
        IF sy-subrc <> 0.
          lv_error = 'WWWDATATAB OBJID missing'.
        ELSE.
          <lv_field> = lv_id.
          IF <lv_field> <> gs_object-obj_name.
            lv_error = 'W3MI key would truncate object name'.
          ENDIF.
        ENDIF.
      ENDIF.
      IF lv_error IS INITIAL.
        lv_table = 'WWWPARAMS'.
        CREATE DATA lr_params TYPE STANDARD TABLE OF (lv_table).
        CREATE DATA lr_params2 TYPE STANDARD TABLE OF (lv_table).
        ASSIGN lr_params->* TO <lt_params>.
        ASSIGN lr_params2->* TO <lt_params2>.
        lv_where = 'RELID = LV_RELID AND OBJID = LV_ID'.
        SELECT * FROM (lv_table) INTO TABLE <lt_params> WHERE (lv_where).
        LOOP AT <lt_params> ASSIGNING <ls_param>.
          ASSIGN COMPONENT 'NAME' OF STRUCTURE <ls_param> TO <lv_field>.
          IF sy-subrc <> 0. lv_error = 'WWWPARAMS NAME missing'. EXIT. ENDIF.
          lv_name = <lv_field>. TRANSLATE lv_name TO LOWER CASE.
          ASSIGN COMPONENT 'VALUE' OF STRUCTURE <ls_param> TO <lv_field>.
          IF sy-subrc <> 0. lv_error = 'WWWPARAMS VALUE missing'. EXIT. ENDIF.
          lv_value = <lv_field>.
          CASE lv_name.
            WHEN 'filesize'. lv_size_text = lv_value.
            WHEN 'filename'. lv_fname = lv_value.
            WHEN 'fileextension'. lv_ext = lv_value.
            WHEN 'mimetype'. lv_mime = lv_value.
          ENDCASE.
        ENDLOOP.
        CONDENSE lv_size_text.
        IF lv_size_text IS INITIAL OR lv_size_text CN '0123456789'
          OR strlen( lv_size_text ) > 8.
          lv_error = 'W3MI exact filesize unavailable; no padded-byte guessing'.
        ELSE.
          lv_size = lv_size_text.
          IF lv_size > 16777216. lv_error = 'W3MI exceeds 16 MiB file limit'. ENDIF.
        ENDIF.
      ENDIF.
      IF lv_error IS INITIAL.
        lv_type = 'W3MIME'.
        CREATE DATA lr_mime TYPE STANDARD TABLE OF (lv_type).
        CREATE DATA lr_again TYPE STANDARD TABLE OF (lv_type).
        ASSIGN lr_mime->* TO <lt_mime>.
        ASSIGN lr_again->* TO <lt_again>.
        CALL FUNCTION lv_fm EXPORTING key = <ls_key>
          TABLES mime = <lt_mime> EXCEPTIONS error_message = 1 OTHERS = 2.
        IF sy-subrc <> 0.
          lv_error = 'WWWDATA_IMPORT read failed'.
        ELSE.
          CALL FUNCTION lv_fm EXPORTING key = <ls_key>
            TABLES mime = <lt_again> EXCEPTIONS error_message = 1 OTHERS = 2.
          IF sy-subrc <> 0 OR <lt_mime> <> <lt_again>.
            lv_error = 'W3MI bytes changed between reads'.
          ENDIF.
        ENDIF.
        SELECT * FROM (lv_table) INTO TABLE <lt_params2> WHERE (lv_where).
        SORT <lt_params>. SORT <lt_params2>.
        IF <lt_params> <> <lt_params2>.
          lv_error = 'W3MI parameters changed between reads'.
        ENDIF.
      ENDIF.
      IF lv_error IS INITIAL.
        PERFORM web_binary USING <lt_mime> lv_size
          CHANGING lv_data lv_ok.
        IF lv_ok IS INITIAL.
          lv_error = 'W3MI binary row type/length inconsistent with filesize'.
        ENDIF.
      ENDIF.
      IF lv_error IS INITIAL.
        IF lv_fname IS INITIAL.
          lv_fname = gs_object-obj_name.
          IF lv_ext IS NOT INITIAL.
            IF lv_ext(1) <> '.'. CONCATENATE '.' lv_ext INTO lv_ext. ENDIF.
            CONCATENATE lv_fname lv_ext INTO lv_fname.
          ELSE.
            CONCATENATE lv_fname '.bin' INTO lv_fname.
          ENDIF.
        ENDIF.
        PERFORM web_leaf USING lv_fname CHANGING lv_leaf.
        CONCATENATE 'content/' lv_leaf INTO lv_path.
        gv_payload_state = 'U'.
        PERFORM web_blob USING lv_path 'W3MI_CONTENT' lv_data.
        CONCATENATE gv_root lv_path INTO ls_asset-content_path.
        CALL TRANSFORMATION id SOURCE object_name = gs_object-obj_name
          parameters = <lt_params> api_metadata = lt_meta
          exact_byte_length = lv_size RESULT XML lv_xml.
        PERFORM add_file USING 'metadata.xml' 'W3MI_METADATA' lv_xml.
        CONCATENATE gv_root 'metadata.xml' INTO ls_asset-metadata_path.
        ls_asset-original_path = lv_fname. ls_asset-mime_type = lv_mime.
        ls_asset-byte_length = lv_size. ls_asset-active_state = 'U'.
        ls_asset-status = 'EXPORTED'.
        ls_asset-detail = 'Raw repository bytes; exact WWWPARAMS filesize; API version U'.
      ENDIF.
    CATCH cx_root INTO lo_error.
      lv_error = lo_error->get_text( ).
  ENDTRY.
  IF lv_error IS NOT INITIAL.
    ls_asset-detail = lv_error. PERFORM web_fail USING lv_error.
  ELSE.
    gs_object-reason = 'Web MIME bytes and parameters read; active version unverified'.
  ENDIF.
  APPEND ls_asset TO gt_web_assets.
  CLEAR: gv_payload_state, gv_file_language, gv_check_mode.
ENDFORM.

FORM finalize_web.
  DATA: lv_xml TYPE xstring, lv_saved_root TYPE string,
        ls_saved_object TYPE ty_object.
  lv_saved_root = gv_root. ls_saved_object = gs_object.
  CLEAR: gv_root, gs_object, gv_file_language, gv_check_mode.
  gv_payload_state = 'U'.
  SORT gt_web_assets BY object obj_name component requested_language kind.
  SORT gt_web_refs BY object obj_name component target_object target_name.
  DELETE ADJACENT DUPLICATES FROM gt_web_refs COMPARING ALL FIELDS.
  CALL TRANSFORMATION id SOURCE assets = gt_web_assets
    references = gt_web_refs RESULT XML lv_xml.
  PERFORM add_file USING 'catalog/web-assets.xml' 'WEB_CATALOG' lv_xml.
  gv_root = lv_saved_root. gs_object = ls_saved_object.
  CLEAR gv_payload_state.
ENDFORM.

FORM test_web_helpers.
  TYPES ty_raw4 TYPE x LENGTH 4.
  TYPES ty_char5 TYPE c LENGTH 5.
  DATA: lt_raw TYPE STANDARD TABLE OF ty_raw4,
        lv_raw TYPE x LENGTH 4, lv_data TYPE xstring,
        lv_ok TYPE c LENGTH 1, lv_name TYPE string,
        lv_leaf TYPE string, lt_lines TYPE ty_lines,
        lv_text TYPE string, lv_expected TYPE string,
        lt_fixed TYPE STANDARD TABLE OF ty_char5,
        lv_fixed TYPE ty_char5.
  lv_raw = 'FF000D0A'. APPEND lv_raw TO lt_raw.
  PERFORM web_binary USING lt_raw 3 CHANGING lv_data lv_ok.
  IF lv_ok <> 'X' OR lv_data <> 'FF000D'.
    gv_fatal = 'Web binary exact-length fixture failed'. RETURN.
  ENDIF.
  PERFORM web_binary USING lt_raw 5 CHANGING lv_data lv_ok.
  IF lv_ok = 'X'.
    gv_fatal = 'Web binary short-content fixture failed'. RETURN.
  ENDIF.
  REFRESH lt_raw.
  PERFORM web_binary USING lt_raw 0 CHANGING lv_data lv_ok.
  IF lv_ok <> 'X' OR lv_data IS NOT INITIAL.
    gv_fatal = 'Web empty binary fixture failed'. RETURN.
  ENDIF.
  lv_name = '/sap/bc/bsp/app/MyScript.js'.
  PERFORM web_leaf USING lv_name CHANGING lv_leaf.
  IF lv_leaf <> 'MyScript.js'.
    gv_fatal = 'Web readable filename fixture failed'. RETURN.
  ENDIF.
  lv_name = '/a/CON'.
  PERFORM web_leaf USING lv_name CHANGING lv_leaf.
  IF lv_leaf <> '~43ON'.
    gv_fatal = 'Web Windows reserved filename fixture failed'. RETURN.
  ENDIF.
  lv_name = '/a/x~.js'.
  PERFORM web_leaf USING lv_name CHANGING lv_leaf.
  IF lv_leaf <> 'x~7E.js'.
    gv_fatal = 'Web filename escaping fixture failed'. RETURN.
  ENDIF.
  APPEND 'first' TO lt_lines. APPEND '' TO lt_lines.
  PERFORM web_lines USING lt_lines CHANGING lv_text lv_ok.
  CONCATENATE 'first' gv_lf gv_lf INTO lv_expected
    RESPECTING BLANKS.
  IF lv_ok <> 'X' OR lv_text <> lv_expected.
    gv_fatal = 'Web source empty-line fixture failed'. RETURN.
  ENDIF.
  lv_fixed = 'A'. APPEND lv_fixed TO lt_fixed.
  PERFORM web_lines USING lt_fixed CHANGING lv_text lv_ok.
  CONCATENATE lv_fixed gv_lf INTO lv_expected RESPECTING BLANKS.
  IF lv_ok <> 'X' OR lv_text <> lv_expected.
    gv_fatal = 'Web source trailing-space fixture failed'. RETURN.
  ENDIF.
ENDFORM.


FORM ddic_table_folder USING pv_class TYPE c
                      CHANGING cv_folder TYPE string.
  CLEAR cv_folder.
  CASE pv_class.
    WHEN 'INTTAB' OR 'APPEND'. cv_folder = 'Structures'.
    WHEN 'TRANSP' OR 'POOL' OR 'CLUSTER'. cv_folder = 'DBtable'.
  ENDCASE.
ENDFORM.

FORM function_tab USING pv_prefix TYPE string pv_tab TYPE c
                        pv_entries TYPE ANY pv_documentation TYPE ANY
                  CHANGING cv_error TYPE string.
  DATA: lv_raw TYPE xstring, lv_xml TYPE xstring,
        lv_tab TYPE string, lv_path TYPE string,
        lo_error TYPE REF TO cx_root.
  CLEAR cv_error.
  lv_tab = pv_tab.
  TRY.
* Preserve the entire parameter record, including default/type/flags.
* API documentation retains original identifiers; no guessed labels.
      CALL TRANSFORMATION id SOURCE tab = lv_tab
        requested_language = gv_language_ko entries = pv_entries
        documentation = pv_documentation RESULT XML lv_raw.
      PERFORM pretty_xml USING lv_raw CHANGING lv_xml cv_error.
      IF cv_error IS INITIAL.
* pretty_xml verifies the output against raw XML, including blank strings.
          CONCATENATE pv_prefix pv_tab '.xml' INTO lv_path.
          gv_file_language = gv_language_ko. gv_payload_state = 'U'.
* Attributes can mix neutral metadata and KO/EN text rows; SPRAS is exact.
          IF pv_tab = 'Attributes'. CLEAR gv_file_language. ENDIF.
          PERFORM add_file USING lv_path 'FUNCTION_TAB' lv_xml.
          IF gv_fatal IS NOT INITIAL. cv_error = gv_fatal. ENDIF.
      ENDIF.
    CATCH cx_root INTO lo_error.
      cv_error = lo_error->get_text( ).
  ENDTRY.
  IF cv_error IS NOT INITIAL.
    PERFORM log USING 'FUNCTION_TAB' 'FAILED' cv_error.
  ENDIF.
  CLEAR gv_file_language.
ENDFORM.

FORM function_attributes USING ps_function TYPE ty_function
                               pv_prefix TYPE string
                               pv_global TYPE rs38l-global
                               pv_remote TYPE rs38l-remote
                               pv_update TYPE rs38l-utask
                         CHANGING cv_error TYPE string.
  TYPES: ty_tfdir_rows TYPE STANDARD TABLE OF tfdir,
         ty_enlfdir_rows TYPE STANDARD TABLE OF enlfdir,
         ty_tftit_rows TYPE STANDARD TABLE OF tftit,
         ty_tlibt_rows TYPE STANDARD TABLE OF tlibt,
         ty_trdir_rows TYPE STANDARD TABLE OF trdir.
  DATA: BEGIN OF ls_attributes,
          function_name TYPE rs38l-name,
          function_group TYPE rs38l-area,
          development_class TYPE tadir-devclass,
          main_program TYPE ty_name,
          global_flag TYPE rs38l-global,
          remote_call TYPE rs38l-remote,
          update_task TYPE rs38l-utask,
          version_verified TYPE c LENGTH 1,
          repository_entry TYPE tadir,
          function_directory TYPE ty_tfdir_rows,
          group_assignment TYPE ty_enlfdir_rows,
          short_text TYPE ty_tftit_rows,
          group_text TYPE ty_tlibt_rows,
          main_program_attributes TYPE ty_trdir_rows,
        END OF ls_attributes,
        ls_directory TYPE tfdir,
        lt_documentation TYPE STANDARD TABLE OF rsfdo.
  CLEAR cv_error.
  ls_attributes-function_name = ps_function-funcname.
  ls_attributes-function_group = ps_function-area.
  ls_attributes-development_class = gs_object-devclass.
  ls_attributes-main_program = ps_function-main_program.
  ls_attributes-global_flag = pv_global.
  ls_attributes-remote_call = pv_remote.
  ls_attributes-update_task = pv_update.
* Repository metadata only; missing KO descriptions may use EN.
  SELECT * FROM tfdir INTO TABLE ls_attributes-function_directory
    WHERE funcname = ps_function-funcname.
  SELECT * FROM enlfdir INTO TABLE ls_attributes-group_assignment
    WHERE funcname = ps_function-funcname AND area = ps_function-area.
  SELECT * FROM tftit INTO TABLE ls_attributes-short_text
    WHERE funcname = ps_function-funcname AND spras = gv_language_ko.
  SELECT * FROM tlibt INTO TABLE ls_attributes-group_text
    WHERE area = ps_function-area AND spras = gv_language_ko.
  IF gv_language_en IS NOT INITIAL.
    IF ls_attributes-short_text IS INITIAL.
      SELECT * FROM tftit INTO TABLE ls_attributes-short_text
        WHERE funcname = ps_function-funcname AND spras = gv_language_en.
      IF ls_attributes-short_text IS NOT INITIAL.
        PERFORM log USING 'LANGUAGE_FALLBACK' 'INFO'
          'Function short text absent in KO; EN selected (SPRAs retained)'.
      ENDIF.
    ENDIF.
    IF ls_attributes-group_text IS INITIAL.
      SELECT * FROM tlibt INTO TABLE ls_attributes-group_text
        WHERE area = ps_function-area AND spras = gv_language_en.
      IF ls_attributes-group_text IS NOT INITIAL.
        PERFORM log USING 'LANGUAGE_FALLBACK' 'INFO'
          'Function group text absent in KO; EN selected (SPRAs retained)'.
      ENDIF.
    ENDIF.
  ENDIF.
  SELECT * FROM trdir INTO TABLE ls_attributes-main_program_attributes
    WHERE name = ps_function-main_program.
  SELECT SINGLE * FROM tadir INTO ls_attributes-repository_entry
    WHERE pgmid = 'R3TR' AND object = 'FUGR'
      AND obj_name = gs_object-obj_name.
  IF ls_attributes-function_directory IS INITIAL OR
     ls_attributes-group_assignment IS INITIAL.
    cv_error = 'Function directory changed before Attributes read'.
    RETURN.
  ENDIF.
  READ TABLE ls_attributes-function_directory INTO ls_directory INDEX 1.
  IF ls_directory-pname <> ps_function-main_program.
    cv_error = 'Function main program changed before Attributes read'.
    RETURN.
  ENDIF.
  PERFORM function_tab USING pv_prefix 'Attributes' ls_attributes
    lt_documentation CHANGING cv_error.
ENDFORM.

FORM bsp_mime_relative USING pv_url TYPE string pv_app TYPE csequence
                      CHANGING cv_relative TYPE string
                               cv_error TYPE string.
  DATA: lv_app TYPE string, lv_bsp TYPE c, lv_valid TYPE c,
        lt_parts TYPE ty_lines, lv_part TYPE string,
        lv_safe TYPE string, lv_index TYPE i, lv_count TYPE i.
  CLEAR: cv_relative, cv_error.
  PERFORM bsp_app_from_url USING pv_url
    CHANGING lv_app lv_bsp lv_valid.
  IF lv_valid IS INITIAL OR lv_app <> pv_app.
    cv_error = 'MIME URL is outside the expected BSP application'. RETURN.
  ENDIF.
  SPLIT pv_url AT '/' INTO TABLE lt_parts.
  DESCRIBE TABLE lt_parts LINES lv_count.
* /SAP/BC/BSP/<namespace>/<app>/... : preserve every relative segment.
  LOOP AT lt_parts INTO lv_part FROM 7.
    lv_index = sy-tabix.
    IF lv_part IS INITIAL AND lv_index = lv_count. CONTINUE. ENDIF.
    IF lv_part IS INITIAL OR lv_part = '.' OR lv_part = '..'.
      cv_error = 'Empty or dot segment in BSP MIME URL'. RETURN.
    ENDIF.
    PERFORM safe_leaf USING lv_part CHANGING lv_safe.
    IF cv_relative IS INITIAL.
      cv_relative = lv_safe.
    ELSE.
      CONCATENATE cv_relative '/' lv_safe INTO cv_relative.
    ENDIF.
  ENDLOOP.
ENDFORM.

FORM mime_type_folder USING pv_mime TYPE string
                      CHANGING cv_folder TYPE string.
  DATA: lv_type TYPE string, lv_params TYPE string,
        lt_parts TYPE ty_lines, lv_major TYPE string,
        lv_minor TYPE string, lv_count TYPE i,
        lv_safe_major TYPE string, lv_safe_minor TYPE string.
  SPLIT pv_mime AT ';' INTO lv_type lv_params.
  TRANSLATE lv_type TO LOWER CASE.
  CONDENSE lv_type.
  SPLIT lv_type AT '/' INTO TABLE lt_parts.
  DESCRIBE TABLE lt_parts LINES lv_count.
  READ TABLE lt_parts INTO lv_major INDEX 1.
  READ TABLE lt_parts INTO lv_minor INDEX 2.
  CONDENSE: lv_major, lv_minor.
  IF lv_count <> 2 OR lv_major IS INITIAL OR lv_minor IS INITIAL.
    cv_folder = 'application/octet-stream'. RETURN.
  ENDIF.
  PERFORM safe_leaf USING lv_major CHANGING lv_safe_major.
  PERFORM safe_leaf USING lv_minor CHANGING lv_safe_minor.
  CONCATENATE lv_safe_major '/' lv_safe_minor INTO cv_folder.
ENDFORM.

FORM mime_group_path USING pv_url TYPE string pv_mime TYPE string
                    CHANGING cv_root TYPE string cv_path TYPE string
                             cv_error TYPE string.
  DATA: lv_pkg TYPE string, lv_group TYPE string, lv_leaf TYPE string,
        lv_key TYPE string, lv_id TYPE string, lv_stem TYPE string,
        lv_ext TYPE string, lv_i TYPE i, lv_dot TYPE i, lv_len TYPE i.
  CLEAR: cv_root, cv_path, cv_error.
  PERFORM segment USING gs_object-devclass CHANGING lv_pkg.
  CONCATENATE 'packages/' lv_pkg '/MIME/' INTO cv_root.
  PERFORM mime_type_folder USING pv_mime CHANGING lv_group.
  PERFORM web_leaf USING pv_url CHANGING lv_leaf.
  CONCATENATE lv_group '/' lv_leaf INTO cv_path.
  CONCATENATE cv_root cv_path INTO lv_key.
  TRANSLATE lv_key TO UPPER CASE.
  READ TABLE gt_paths WITH TABLE KEY table_line = lv_key
    TRANSPORTING NO FIELDS.
  IF sy-subrc <> 0. RETURN. ENDIF.
* Do not overwrite/deduplicate distinct LOIOs with the same filename.
* Only collisions get the original object ID before the extension.
  PERFORM segment USING gs_object-obj_name CHANGING lv_id.
  lv_dot = -1. lv_len = strlen( lv_leaf ).
  DO lv_len TIMES.
    lv_i = sy-index - 1.
    IF lv_leaf+lv_i(1) = '.'. lv_dot = lv_i. ENDIF.
  ENDDO.
  IF lv_dot > 0.
    lv_stem = lv_leaf(lv_dot). lv_ext = lv_leaf+lv_dot.
  ELSE.
    lv_stem = lv_leaf.
  ENDIF.
  CONCATENATE lv_group '/' lv_stem '~' lv_id lv_ext INTO cv_path.
  CONCATENATE cv_root cv_path INTO lv_key.
  TRANSLATE lv_key TO UPPER CASE.
  READ TABLE gt_paths WITH TABLE KEY table_line = lv_key
    TRANSPORTING NO FIELDS.
  IF sy-subrc = 0.
    cv_error = 'MIME output path still collides after object-ID suffix'.
  ENDIF.
ENDFORM.

FORM mime_metadata_path USING pv_package TYPE c
                       CHANGING cv_path TYPE string.
  DATA lv_pkg TYPE string.
  PERFORM segment USING pv_package CHANGING lv_pkg.
  CONCATENATE 'packages/' lv_pkg '/MIME/metadata.xml' INTO cv_path.
ENDFORM.

FORM mime_metadata_add USING ps_asset TYPE ty_web_asset
                            pv_loio TYPE sdok_docid
                            pv_phio TYPE sdok_phid pv_folder TYPE c.
  DATA ls_meta TYPE ty_mime_metadata.
  ls_meta-object = ps_asset-object.
  ls_meta-obj_name = ps_asset-obj_name.
  ls_meta-devclass = ps_asset-devclass.
  ls_meta-loio = pv_loio. ls_meta-phio = pv_phio.
  ls_meta-url = ps_asset-original_path.
  ls_meta-is_folder = pv_folder.
  ls_meta-mime_type = ps_asset-mime_type.
  ls_meta-requested_language = ps_asset-requested_language.
  ls_meta-actual_language = ps_asset-language.
  ls_meta-byte_length = ps_asset-byte_length.
  ls_meta-content_path = ps_asset-content_path.
  ls_meta-active_state = ps_asset-active_state.
  ls_meta-status = ps_asset-status. ls_meta-detail = ps_asset-detail.
  APPEND ls_meta TO gt_mime_metadata.
ENDFORM.

FORM finalize_mime.
  DATA: lt_meta TYPE STANDARD TABLE OF ty_mime_metadata,
        ls_meta TYPE ty_mime_metadata, ls_pkg TYPE ty_package,
        ls_saved_object TYPE ty_object, lv_saved_root TYPE string,
        lv_xml TYPE xstring, lv_path TYPE string.
  ls_saved_object = gs_object. lv_saved_root = gv_root.
  SORT gt_mime_metadata BY devclass loio.
  LOOP AT gt_packages INTO ls_pkg.
    REFRESH lt_meta.
    LOOP AT gt_mime_metadata INTO ls_meta WHERE devclass = ls_pkg-devclass.
      APPEND ls_meta TO lt_meta.
    ENDLOOP.
    IF lt_meta IS INITIAL. CONTINUE. ENDIF.
    CLEAR: gs_object, gv_root, gv_file_language, gv_check_mode.
    gs_object-devclass = ls_pkg-devclass. gv_payload_state = 'U'.
    PERFORM mime_metadata_path USING ls_pkg-devclass CHANGING lv_path.
    CALL TRANSFORMATION id SOURCE development_class = ls_pkg-devclass
      entries = lt_meta RESULT XML lv_xml.
    PERFORM add_file USING lv_path 'MIME_METADATA' lv_xml.
    IF gv_fatal IS NOT INITIAL. EXIT. ENDIF.
  ENDLOOP.
  gs_object = ls_saved_object. gv_root = lv_saved_root.
  CLEAR: gv_file_language, gv_payload_state, gv_check_mode.
ENDFORM.

FORM mime_output_path USING pv_url TYPE string pv_folder TYPE c
                           pv_mime TYPE string
                     CHANGING cv_root TYPE string cv_path TYPE string
                              cv_error TYPE string.
  DATA: lv_app TYPE string, lv_bsp TYPE c, lv_valid TYPE c,
        lv_relative TYPE string, lv_app_name TYPE tadir-obj_name,
        lv_package TYPE tadir-devclass, lv_pkg TYPE string,
        lv_name TYPE string, lv_leaf TYPE string.
  CLEAR: cv_path, cv_error.
  cv_root = gv_root.
  PERFORM bsp_app_from_url USING pv_url
    CHANGING lv_app lv_bsp lv_valid.
  IF lv_bsp IS INITIAL.
    PERFORM mime_group_path USING pv_url pv_mime
      CHANGING cv_root cv_path cv_error. RETURN.
  ENDIF.
  IF lv_valid IS INITIAL.
    cv_error = 'BSP MIME URL cannot be routed safely'. RETURN.
  ENDIF.
  lv_app_name = lv_app.
  SELECT SINGLE devclass FROM tadir INTO lv_package
    WHERE pgmid = 'R3TR' AND object = 'WAPA' AND obj_name = lv_app_name.
  IF sy-subrc <> 0.
    cv_error = 'BSP owner disappeared before MIME path routing'. RETURN.
  ENDIF.
  READ TABLE gt_seen_pkg WITH TABLE KEY devclass = lv_package
    TRANSPORTING NO FIELDS.
  IF sy-subrc <> 0.
    cv_error = 'BSP package changed before MIME path routing'. RETURN.
  ENDIF.
  PERFORM bsp_mime_relative USING pv_url lv_app
    CHANGING lv_relative cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  IF lv_relative IS INITIAL AND pv_folder IS INITIAL.
    cv_error = 'BSP MIME file has no relative filename'. RETURN.
  ENDIF.
  PERFORM segment USING lv_package CHANGING lv_pkg.
  PERFORM segment USING lv_app_name CHANGING lv_name.
  CONCATENATE 'packages/' lv_pkg '/BSP Application/WAPA/' lv_name '/'
    INTO cv_root.
  CONCATENATE 'MIMEs/' lv_relative INTO cv_path.
ENDFORM.

FORM export_bsp_mimes USING pv_app TYPE o2applname.
  DATA: lo_mime TYPE REF TO if_mr_api,
        lt_files TYPE string_table,
        lt_seen TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line,
        ls_io TYPE skwf_io, lv_id TYPE tadir-obj_name,
        lv_url TYPE string, lv_base TYPE string, lv_tail TYPE string,
        lv_relative TYPE string, lv_error TYPE string,
        lv_folder TYPE boole_d, lv_index TYPE i,
        lv_package TYPE tadir-devclass,
        ls_parent TYPE ty_object, ls_child TYPE ty_object,
        ls_ref TYPE ty_web_ref, lv_root TYPE string,
        lv_parent_failed TYPE c, lo_error TYPE REF TO cx_root.
  FIELD-SYMBOLS <lv_id> TYPE ANY.
  ls_parent = gs_object. lv_root = gv_root.
  IF pv_app(1) = '/'.
    lv_tail = pv_app+1.
    CONCATENATE '/SAP/BC/BSP/' lv_tail INTO lv_base.
  ELSE.
    CONCATENATE '/SAP/BC/BSP/SAP/' pv_app INTO lv_base.
  ENDIF.
  TRY.
      lo_mime = cl_mime_repository_api=>get_api( ).
      IF lo_mime IS INITIAL.
        PERFORM web_fail USING 'MIME repository API unavailable'. RETURN.
      ENDIF.
* A missing MIME root means the app has no repository MIME subtree.
      CALL METHOD lo_mime->get_io_for_url EXPORTING i_url = lv_base
        IMPORTING e_loio = ls_io e_is_folder = lv_folder
        EXCEPTIONS not_found = 1 OTHERS = 2.
      IF sy-subrc = 1.
        PERFORM log USING 'BSP_MIME_TREE' 'INFO'
          'No MIME repository root for this BSP application'. RETURN.
      ELSEIF sy-subrc <> 0 OR lv_folder <> 'X'.
        PERFORM web_fail USING 'BSP MIME root lookup failed'. RETURN.
      ENDIF.
      CALL METHOD lo_mime->file_list
        EXPORTING i_url = lv_base i_recursive_call = 'X'
          i_check_authority = 'X'
        IMPORTING e_files = lt_files EXCEPTIONS OTHERS = 1.
      IF sy-subrc <> 0.
        PERFORM web_fail USING 'BSP MIME tree inventory failed'. RETURN.
      ENDIF.
      LOOP AT lt_files INTO lv_url.
        IF lv_url IS INITIAL. CONTINUE. ENDIF.
        IF lv_url(1) <> '/'.
          CONCATENATE lv_base '/' lv_url INTO lv_url.
        ENDIF.
        INSERT lv_url INTO TABLE lt_seen.
        IF sy-subrc <> 0. CONTINUE. ENDIF.
        CLEAR: lv_error, ls_io, lv_folder, lv_id, lv_package, ls_ref.
        PERFORM bsp_mime_relative USING lv_url pv_app
          CHANGING lv_relative lv_error.
        IF lv_error IS NOT INITIAL.
          PERFORM web_fail USING lv_error.
          lv_parent_failed = 'X'. CONTINUE.
        ENDIF.
        CALL METHOD lo_mime->get_io_for_url EXPORTING i_url = lv_url
          IMPORTING e_loio = ls_io e_is_folder = lv_folder
          EXCEPTIONS OTHERS = 1.
        IF sy-subrc <> 0.
          PERFORM web_fail USING 'BSP MIME item URL resolution failed'.
          lv_parent_failed = 'X'. CONTINUE.
        ENDIF.
        ASSIGN COMPONENT 'OBJID' OF STRUCTURE ls_io TO <lv_id>.
        IF sy-subrc <> 0 OR <lv_id> IS INITIAL.
          PERFORM web_fail USING 'BSP MIME LOIO OBJID unavailable'.
          lv_parent_failed = 'X'. CONTINUE.
        ENDIF.
        lv_id = <lv_id>.
        READ TABLE gt_objects INTO ls_child WITH KEY
          pgmid = 'R3TR' object = 'SMIM' obj_name = lv_id.
        lv_index = sy-tabix.
        IF sy-subrc = 0.
* Use the catalogued object's own authorization/package checks. Preserve
* its result and avoid a second body read on its normal catalog turn.
          gs_object = ls_child.
          PERFORM export_object.
          MODIFY gt_objects FROM gs_object INDEX lv_index.
          IF gs_object-status = 'FAILED'. lv_parent_failed = 'X'. ENDIF.
          gs_object = ls_parent. gv_root = lv_root.
          IF gv_fatal IS NOT INITIAL. EXIT. ENDIF.
        ELSE.
          ls_ref-object = 'WAPA'. ls_ref-obj_name = pv_app.
          ls_ref-component = lv_url. ls_ref-target_object = 'SMIM'.
          ls_ref-target_name = lv_id.
          ls_ref-evidence = 'BSP_MIME_TREE_TADIR'.
          SELECT SINGLE devclass FROM tadir INTO lv_package
            WHERE pgmid = 'R3TR' AND object = 'SMIM' AND obj_name = lv_id.
          ls_ref-target_package = lv_package.
          IF sy-subrc <> 0.
            ls_ref-scope = 'OWNER_UNRESOLVED'.
            PERFORM log USING 'BSP_MIME_SCOPE' 'UNRESOLVED'
              'MIME LOIO has no TADIR owner; body not read'.
          ELSE.
            READ TABLE gt_seen_pkg WITH TABLE KEY devclass = lv_package
              TRANSPORTING NO FIELDS.
            IF sy-subrc <> 0.
              ls_ref-scope = 'EXTERNAL_REFERENCE_ONLY'.
            ELSE.
              ls_ref-scope = 'OWNER_UNRESOLVED'.
              PERFORM log USING 'BSP_MIME_SCOPE' 'UNRESOLVED'
                'MIME owner in scope but missing from initial catalog'.
            ENDIF.
          ENDIF.
          APPEND ls_ref TO gt_web_refs.
        ENDIF.
      ENDLOOP.
    CATCH cx_root INTO lo_error.
      lv_error = lo_error->get_text( ).
      gs_object = ls_parent. gv_root = lv_root.
      PERFORM web_fail USING lv_error. RETURN.
  ENDTRY.
  gs_object = ls_parent. gv_root = lv_root. gv_component = pv_app.
  IF lv_parent_failed = 'X'.
    PERFORM web_fail USING 'One or more in-scope BSP MIME items failed'.
  ENDIF.
ENDFORM.
