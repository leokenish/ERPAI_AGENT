REPORT z_package_diag LINE-SIZE 255 NO STANDARD PAGE HEADING.
* DEVHUB DIAG 0.7.1 - guarded existing web MIME replacement.
* Based on DIAG 0.4.5 / Export 0.3.18, SAP_BASIS 700 Unicode.
* BSP Layout: existing pages only; other BSP tabs are preserved.
* Standalone ABAP/DDIC sources remain diagnosis-only.
* Web mode: explicit selection -> lock -> re-read -> verified backup
* -> CTS -> repository save -> COMMIT -> read-back byte verification.
* No create/delete/rename, ITS publishing, transport release or import.
* BSP uses a single WAPP activation; MIME does not need activation.
* Repository verification is not browser execution proof.
* Original A/B/C diagnosis is retained as a pre-apply snapshot.
* Post-apply results are separate columns; rerun to take a fresh snapshot.
* Local checks do not replace syntax and execution checks on target SAP.
TYPE-POOLS: abap, slis, sdydo.
TABLES: tdevc, tadir.
DATA gv_language_selection TYPE c LENGTH 2.
DATA: gv_scope_kind TYPE c LENGTH 12,
       gv_scope_package TYPE tadir-devclass,
       gv_bsp_flat TYPE c LENGTH 1.

SELECTION-SCREEN BEGIN OF BLOCK b_scope WITH FRAME TITLE c_scope.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN POSITION 3.
PARAMETERS p_pkgm RADIOBUTTON GROUP scp DEFAULT 'X' USER-COMMAND scmd.
SELECTION-SCREEN COMMENT 5(20) c_pkgm FOR FIELD p_pkgm.
SELECTION-SCREEN POSITION 30.
PARAMETERS p_bspm RADIOBUTTON GROUP scp.
SELECTION-SCREEN COMMENT 32(30) c_bspm FOR FIELD p_bspm.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 2(25) c_pack FOR FIELD p_pack MODIF ID pkg.
PARAMETERS p_pack TYPE tdevc-devclass MODIF ID pkg.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 2(25) c_bsp FOR FIELD p_bsp MODIF ID bsp.
PARAMETERS p_bsp TYPE o2applname MODIF ID bsp.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b_scope.
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK b_file WITH FRAME TITLE c_input.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 2(25) c_file FOR FIELD p_file.
PARAMETERS p_file TYPE c LENGTH 255 LOWER CASE
  VISIBLE LENGTH 45.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b_file.
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK b_extra WITH FRAME TITLE c_extra.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN POSITION 3.
PARAMETERS p_all RADIOBUTTON GROUP rtyp MODIF ID rsl.
SELECTION-SCREEN COMMENT 5(10) c_all FOR FIELD p_all.
SELECTION-SCREEN POSITION 17.
PARAMETERS p_src RADIOBUTTON GROUP rtyp DEFAULT 'X' MODIF ID rsl.
SELECTION-SCREEN COMMENT 19(14) c_src FOR FIELD p_src.
SELECTION-SCREEN POSITION 36.
PARAMETERS p_xml RADIOBUTTON GROUP rtyp MODIF ID rsl.
SELECTION-SCREEN COMMENT 38(8) c_xml FOR FIELD p_xml.
SELECTION-SCREEN POSITION 49.
PARAMETERS p_mime RADIOBUTTON GROUP rtyp MODIF ID rsl.
SELECTION-SCREEN COMMENT 51(27) c_mime FOR FIELD p_mime.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN POSITION 3.
PARAMETERS p_diff AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN COMMENT 5(60) c_diff FOR FIELD p_diff.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 3(28) c_task FOR FIELD p_task.
PARAMETERS p_task TYPE e070-trkorr.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b_extra.
RANGES s_lang FOR gv_language_selection.
PARAMETERS p_sub TYPE c LENGTH 1 DEFAULT 'X' NO-DISPLAY.
PARAMETERS p_mb TYPE i DEFAULT 512 NO-DISPLAY.
* Internal read-only probe: a fresh internal session avoids API object caches.
PARAMETERS p_bspr TYPE c NO-DISPLAY.

* BSP API version is a one-character A/I flag; no optional DDIC alias.
TYPES ty_bsp_version TYPE c LENGTH 1.

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
         scope_kind TYPE c LENGTH 12,
         bsp_application TYPE o2applname,
         bsp_package TYPE tadir-devclass,
         path_layout TYPE c LENGTH 20,
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


TYPES im_char255 TYPE c LENGTH 255.
TYPES im_files TYPE STANDARD TABLE OF ty_file.
TYPES: BEGIN OF im_blob,
         path TYPE string, data TYPE xstring,
       END OF im_blob.
TYPES: BEGIN OF im_entry,
         path TYPE string, original TYPE string, size TYPE i,
       END OF im_entry.
TYPES im_entries TYPE SORTED TABLE OF im_entry WITH UNIQUE KEY path.
TYPES: BEGIN OF im_result,
         id TYPE i, light TYPE c LENGTH 1,
         wa_sel TYPE c, wa_light TYPE c LENGTH 4, wa_ready TYPE c,
         wa_state TYPE c LENGTH 24, wa_note TYPE c LENGTH 255,
         wa_url TYPE c LENGTH 255, wa_lang TYPE sy-langu,
         wa_mime TYPE c LENGTH 100, wa_task TYPE e070-trkorr,
         wa_after TYPE i, wa_date TYPE sy-datum, wa_time TYPE sy-uzeit,
         wa_app TYPE o2applname, wa_page TYPE o2pagkey-pagekey,
         wa_page_type TYPE c LENGTH 32, wa_inactive TYPE c LENGTH 16, wa_save TYPE c LENGTH 24,
         wa_inactive_detail TYPE string, wa_verify_detail TYPE string,
         wa_activate TYPE c LENGTH 24,
         comparison TYPE c LENGTH 24,
         comparison_text TYPE c LENGTH 24,
         zip_change_text TYPE c LENGTH 24, sap_change_text TYPE c LENGTH 24,
         zip_change TYPE c LENGTH 24, sap_change TYPE c LENGTH 24,
         read_state TYPE c LENGTH 26, read_note TYPE c LENGTH 255,
         read_text TYPE c LENGTH 26,
         version_state TYPE c LENGTH 26, version_note TYPE c LENGTH 255,
         version_text TYPE c LENGTH 26,
         validation TYPE c LENGTH 26, validation_text TYPE c LENGTH 26,
         format_text TYPE c LENGTH 26,
         xml_ab TYPE c LENGTH 26, xml_ac TYPE c LENGTH 26, xml_bc TYPE c LENGTH 26,
         xml_ab_text TYPE c LENGTH 26, xml_ac_text TYPE c LENGTH 26,
         xml_bc_text TYPE c LENGTH 26,
         xml_ab_note TYPE c LENGTH 255, xml_ac_note TYPE c LENGTH 255,
         xml_note TYPE c LENGTH 255,
         xml_scope_ab TYPE c LENGTH 255, xml_scope_ac TYPE c LENGTH 255,
         xml_scope_cb TYPE c LENGTH 255, validation_note TYPE c LENGTH 255,
         devclass TYPE tadir-devclass, object TYPE tadir-object,
         obj_name TYPE tadir-obj_name,
         path TYPE c LENGTH 255, component TYPE c LENGTH 80,
         filename TYPE c LENGTH 255,
         bytes_a TYPE i, bytes_b TYPE i, bytes_c TYPE i,
         a_ok TYPE c, b_ok TYPE c, c_ok TYPE c,
         a_state TYPE c, b_state TYPE c, c_state TYPE c,
         pair_ab TYPE c LENGTH 12, pair_ac TYPE c LENGTH 12,
         pair_cb TYPE c LENGTH 12, pair_note TYPE c LENGTH 255,
         active_a TYPE c, active_c TYPE c,
         ab_format TYPE c LENGTH 24,
         error_program TYPE ty_name, error_line TYPE i,
         message TYPE c LENGTH 255,
       END OF im_result.
TYPES: BEGIN OF im_version_proof,
         path TYPE string, state TYPE c LENGTH 26, note TYPE c LENGTH 255,
       END OF im_version_proof.
TYPES: BEGIN OF im_function_link,
         api_path TYPE string, include_path TYPE string, function_prefix TYPE string,
         function_name TYPE rs38l-name, group_name TYPE tadir-obj_name,
         include_name TYPE ty_name,
       END OF im_function_link.
DATA im_function_links TYPE HASHED TABLE OF im_function_link WITH UNIQUE KEY api_path.
DATA im_function_proofs TYPE HASHED TABLE OF im_version_proof WITH UNIQUE KEY path.
DATA im_tab_proofs TYPE HASHED TABLE OF im_version_proof WITH UNIQUE KEY path.
DATA: im_interface_prepared TYPE c, im_interface_ready TYPE c,
      im_interface_error TYPE string,
      im_progress_stage TYPE string, im_progress_done TYPE i,
      im_progress_total TYPE i, im_progress_time TYPE sy-uzeit,
      im_progress_date TYPE sy-datum, im_progress_sent TYPE c.
TYPES: BEGIN OF im_source,
         name TYPE ty_name, path TYPE string, alias TYPE string,
         data TYPE xstring, changed TYPE c, edited TYPE c,
         subc TYPE trdir-subc, error TYPE string,
       END OF im_source.
TYPES: BEGIN OF im_map,
         program TYPE ty_name, path TYPE string,
         line TYPE i,
       END OF im_map.
TYPES im_maps TYPE STANDARD TABLE OF im_map.
TYPES: BEGIN OF im_check,
         path TYPE string, status TYPE c LENGTH 26,
         program TYPE ty_name, line TYPE i, message TYPE string,
       END OF im_check.
TYPES im_paths TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
TYPES: BEGIN OF im_diff,
         kind TYPE c, old_line TYPE i, new_line TYPE i,
         text TYPE string,
       END OF im_diff.
TYPES im_diffs TYPE STANDARD TABLE OF im_diff.
TYPES: BEGIN OF im_xml_node,
         path TYPE string, value TYPE string,
       END OF im_xml_node.
TYPES im_xml_nodes TYPE SORTED TABLE OF im_xml_node WITH UNIQUE KEY path.
TYPES: BEGIN OF im_view_row,
         seq TYPE i, section TYPE c LENGTH 24,
         zip_sap_kind TYPE c LENGTH 12,
         zip_kind TYPE c LENGTH 12, sap_kind TYPE c LENGTH 12,
         block TYPE i, base_pos TYPE c LENGTH 12, base_text TYPE c LENGTH 128,
         zip_pos TYPE c LENGTH 12, zip_text TYPE c LENGTH 128,
         sap_pos TYPE c LENGTH 12, sap_text TYPE c LENGTH 128,
         part TYPE i, color TYPE c LENGTH 4,
       END OF im_view_row.
TYPES: BEGIN OF im_side_row,
         anchor TYPE i, slot TYPE i, side_line TYPE i,
         present TYPE c, text TYPE string,
       END OF im_side_row.
TYPES im_side_rows TYPE SORTED TABLE OF im_side_row WITH UNIQUE KEY anchor slot.
TYPES: BEGIN OF im_side_key, anchor TYPE i, slot TYPE i, END OF im_side_key.
TYPES im_side_keys TYPE SORTED TABLE OF im_side_key WITH UNIQUE KEY anchor slot.
TYPES: BEGIN OF im_logic_row,
         base_line TYPE i, zip_line TYPE i, sap_line TYPE i,
         base_text TYPE string, zip_text TYPE string, sap_text TYPE string,
         hbase TYPE c, hzip TYPE c, hsap TYPE c,
         zip_kind TYPE c LENGTH 12, sap_kind TYPE c LENGTH 12,
       END OF im_logic_row.
TYPES im_logic_rows TYPE STANDARD TABLE OF im_logic_row.
DATA: im_view TYPE STANDARD TABLE OF im_view_row,
      im_view_result TYPE im_result,
      im_view_bytes_a TYPE c LENGTH 16,
      im_view_bytes_b TYPE c LENGTH 16,
      im_view_bytes_c TYPE c LENGTH 16,
      im_view_limited TYPE c, im_view_group TYPE i.
DATA: im_zip_b TYPE REF TO cl_abap_zip,
      im_entries_b TYPE im_entries,
      im_header TYPE ty_header,
      im_manifest TYPE im_files,
      im_manifest_index TYPE SORTED TABLE OF ty_file WITH UNIQUE KEY path,
      im_packages TYPE ty_packages,
      im_current TYPE HASHED TABLE OF im_blob WITH UNIQUE KEY path,
      im_current_index TYPE SORTED TABLE OF ty_file WITH UNIQUE KEY path,
      im_results TYPE STANDARD TABLE OF im_result,
      im_all_results TYPE STANDARD TABLE OF im_result,
      im_sources TYPE SORTED TABLE OF im_source WITH UNIQUE KEY name,
      im_checks TYPE SORTED TABLE OF im_check WITH UNIQUE KEY path,
      im_stack TYPE SORTED TABLE OF ty_name WITH UNIQUE KEY table_line,
      im_cr TYPE string, im_crlf TYPE string,
      im_baseline_mode TYPE c LENGTH 24,
      im_started_date TYPE sy-datum, im_started_time TYPE sy-uzeit,
      im_finished_date TYPE sy-datum, im_finished_time TYPE sy-uzeit,
      im_count TYPE i, im_units TYPE i,
      im_program TYPE sy-repid,
      im_title TYPE lvc_title,
      im_fcat TYPE slis_t_fieldcat_alv,
      im_layout TYPE slis_layout_alv.

TYPES: BEGIN OF im_absence_row,
         object TYPE tadir-object, obj_name TYPE tadir-obj_name, state TYPE c,
       END OF im_absence_row.
DATA im_absence TYPE HASHED TABLE OF im_absence_row WITH UNIQUE KEY object obj_name.
TYPES: BEGIN OF im_head_compare_row,
         label TYPE c LENGTH 40,
         added TYPE i, missing TYPE i, modified TYPE i, same TYPE i, total TYPE i,
       END OF im_head_compare_row.
TYPES: BEGIN OF im_head_verify_row,
         label TYPE c LENGTH 40,
         status1 TYPE c LENGTH 60, count1 TYPE i,
         status2 TYPE c LENGTH 60, count2 TYPE i,
         status3 TYPE c LENGTH 60, count3 TYPE i,
         status4 TYPE c LENGTH 60, count4 TYPE i,
         status5 TYPE c LENGTH 60, count5 TYPE i,
         status6 TYPE c LENGTH 60, count6 TYPE i,
         status7 TYPE c LENGTH 60, count7 TYPE i,
         status8 TYPE c LENGTH 60, count8 TYPE i,
         status9 TYPE c LENGTH 60, count9 TYPE i,
         status10 TYPE c LENGTH 60, count10 TYPE i,
         status11 TYPE c LENGTH 60, count11 TYPE i,
         status12 TYPE c LENGTH 60, count12 TYPE i,
         status13 TYPE c LENGTH 60, count13 TYPE i,
         status14 TYPE c LENGTH 60, count14 TYPE i,
         status15 TYPE c LENGTH 60, count15 TYPE i,
         status16 TYPE c LENGTH 60, count16 TYPE i,
         status17 TYPE c LENGTH 60, count17 TYPE i,
         status18 TYPE c LENGTH 60, count18 TYPE i,
         status19 TYPE c LENGTH 60, count19 TYPE i,
         status20 TYPE c LENGTH 60, count20 TYPE i,
         status21 TYPE c LENGTH 60, count21 TYPE i,
         status22 TYPE c LENGTH 60, count22 TYPE i,
         status23 TYPE c LENGTH 60, count23 TYPE i,
         status24 TYPE c LENGTH 60, count24 TYPE i,
         status25 TYPE c LENGTH 60, count25 TYPE i,
         status26 TYPE c LENGTH 60, count26 TYPE i,
         status27 TYPE c LENGTH 60, count27 TYPE i,
         status28 TYPE c LENGTH 60, count28 TYPE i,
         status29 TYPE c LENGTH 60, count29 TYPE i,
         status30 TYPE c LENGTH 60, count30 TYPE i,
         status31 TYPE c LENGTH 60, count31 TYPE i,
         status32 TYPE c LENGTH 60, count32 TYPE i,
       END OF im_head_verify_row.
TYPES: BEGIN OF im_head_detail_row,
         label TYPE c LENGTH 40, value TYPE c LENGTH 255,
       END OF im_head_detail_row.
DATA: im_head_compare TYPE STANDARD TABLE OF im_head_compare_row,
      im_head_verify TYPE STANDARD TABLE OF im_head_verify_row,
      im_head_detail_a TYPE STANDARD TABLE OF im_head_detail_row,
      im_head_detail_b TYPE STANDARD TABLE OF im_head_detail_row,
      im_head_slots TYPE i,
      im_head_dock TYPE REF TO cl_gui_docking_container,
      im_head_split TYPE REF TO cl_gui_splitter_container,
      im_head_cell_a TYPE REF TO cl_gui_container,
      im_head_cell_b TYPE REF TO cl_gui_container,
      im_head_grid_a TYPE REF TO cl_gui_alv_grid,
      im_head_grid_b TYPE REF TO cl_gui_alv_grid,
      im_head_failed TYPE c.

TYPES: BEGIN OF im_history_row,
         path TYPE string, is_prefix TYPE c,
         changed_by TYPE c LENGTH 40, changed_on TYPE c LENGTH 8,
         origin TYPE c LENGTH 50,
       END OF im_history_row.
DATA: im_history TYPE HASHED TABLE OF im_history_row WITH UNIQUE KEY path,
      im_total_results TYPE i, im_filter_label TYPE c LENGTH 12.

DATA: im_body_fit_active TYPE c, im_body_fit_busy TYPE c,
      im_screen_mode TYPE c, im_toolbar_grid TYPE REF TO cl_gui_alv_grid.
TYPES: BEGIN OF im_proof_row,
         seq TYPE i, kind TYPE c LENGTH 24, api_line TYPE i,
         api_text TYPE c LENGTH 128, include_line TYPE i,
         include_text TYPE c LENGTH 128, part TYPE i, color TYPE c LENGTH 4,
       END OF im_proof_row.
TYPES im_proof_rows TYPE STANDARD TABLE OF im_proof_row.
* Web write state is independent of the diagnostic A/B/C snapshot.
TYPES: BEGIN OF wa_so2_attr,
         name TYPE string, uri TYPE string, value TYPE string,
       END OF wa_so2_attr.
TYPES wa_so2_attrs TYPE STANDARD TABLE OF wa_so2_attr WITH DEFAULT KEY.
TYPES: BEGIN OF wa_so2_part,
         row TYPE i, col TYPE i, original TYPE string, wanted TYPE string,
       END OF wa_so2_part.
TYPES wa_so2_parts TYPE STANDARD TABLE OF wa_so2_part WITH DEFAULT KEY.
TYPES wa_bsp_worklist TYPE STANDARD TABLE OF dwinactiv WITH DEFAULT KEY.
TYPES wa_bsp_protocol_rows TYPE STANDARD TABLE OF sprot_u WITH DEFAULT KEY.
TYPES: BEGIN OF wa_bsp_snapshot,
         attrs TYPE o2pagattr, events TYPE o2pagevh_tabletype,
         parameters TYPE o2pagpar_tabletype, types TYPE rswsourcet,
         layout TYPE xstring, content TYPE o2pageline_table,
         app_attrs TYPE o2applattr, inactive TYPE ty_bsp_keys, app_inactive TYPE c,
         inactive_detail TYPE string,
         error TYPE string,
       END OF wa_bsp_snapshot.
TYPES: BEGIN OF wa_bsp_request,
         key TYPE o2pagkey, langu TYPE sy-langu, nonce TYPE i, version TYPE ty_bsp_version,
       END OF wa_bsp_request.
TYPES: BEGIN OF wa_bsp_app,
         name TYPE o2applname, api TYPE REF TO cl_o2_api_application,
         holders TYPE i,
       END OF wa_bsp_app.
DATA: wa_bsp_apps TYPE STANDARD TABLE OF wa_bsp_app,
      wa_bsp_nonce TYPE i,
      wa_top_dock TYPE REF TO cl_gui_docking_container,
      wa_top_bar TYPE REF TO cl_gui_toolbar,
      wa_top_failed TYPE c, wa_top_mode TYPE c.
TYPES: BEGIN OF wa_target,
         id TYPE i, file TYPE ty_file, asset TYPE ty_web_asset,
         meta TYPE ty_mime_metadata, before TYPE xstring, wanted TYPE xstring,
         io TYPE sdokobject, phio TYPE sdok_phid, locked TYPE c,
         selected TYPE c, eligible TYPE c, task TYPE e070-trkorr,
         params TYPE STANDARD TABLE OF wwwparams WITH DEFAULT KEY,
         wwwkey TYPE wwwdatatab,
         bsp_key TYPE o2pagkey, bsp_objkey TYPE e071-obj_name,
         bsp_path TYPE ty_bsp_path, bsp_map TYPE string,
         bsp_prefix TYPE string, bsp_snapshot TYPE wa_bsp_snapshot,
         bsp_expected TYPE o2pageline_table, bsp_guard TYPE xstring,
         bsp_save TYPE c LENGTH 24, bsp_activate TYPE c LENGTH 24,
         bsp_phase TYPE c LENGTH 24, bsp_resume TYPE c,
       END OF wa_target.
TYPES: BEGIN OF wa_event,
         seq TYPE i, id TYPE i, run TYPE i, path TYPE string,
         phase TYPE c LENGTH 24, state TYPE c LENGTH 24,
         detail TYPE string, user_name TYPE sy-uname,
         date TYPE sy-datum, time TYPE sy-uzeit,
       END OF wa_event.
DATA: wa_targets TYPE STANDARD TABLE OF wa_target,
      wa_assets_a TYPE STANDARD TABLE OF ty_web_asset,
      wa_meta_a TYPE STANDARD TABLE OF ty_mime_metadata,
      wa_events TYPE STANDARD TABLE OF wa_event,
      wa_busy TYPE c, wa_touched TYPE c, wa_run TYPE i,
      wa_backup TYPE string, wa_journal TYPE string,
      wa_journal_owned TYPE c, wa_log_error TYPE string,
      wa_catalog_error TYPE string.

CLASS lcl_im_alv_fit DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS after_refresh FOR EVENT after_refresh OF cl_gui_alv_grid
      IMPORTING sender.
    CLASS-METHODS toolbar FOR EVENT toolbar OF cl_gui_alv_grid
      IMPORTING e_object sender.
    CLASS-METHODS command FOR EVENT user_command OF cl_gui_alv_grid
      IMPORTING e_ucomm sender.
    CLASS-METHODS top_command FOR EVENT function_selected OF cl_gui_toolbar
      IMPORTING fcode.
ENDCLASS.
CLASS lcl_im_alv_fit IMPLEMENTATION.
  METHOD top_command.
    DATA lo_grid TYPE REF TO cl_gui_alv_grid.
    IF wa_busy = 'X'. RETURN. ENDIF.
    CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR' IMPORTING e_grid = lo_grid.
    IF lo_grid IS INITIAL. RETURN. ENDIF.
    IF im_screen_mode = 'M'.
      CASE fcode.
        WHEN 'ZSAVE'. PERFORM wa_apply USING lo_grid.
        WHEN 'ZWA_LOG'. PERFORM wa_log_download.
        WHEN 'ZJSON'. PERFORM im_json_download.
      ENDCASE.
    ELSEIF im_screen_mode = 'D' AND fcode = 'ZPROOF'.
      PERFORM im_proof_grid.
    ENDIF.
  ENDMETHOD.
  METHOD after_refresh.
    DATA lo_current TYPE REF TO cl_gui_alv_grid.
* The fullscreen grid may not exist yet in the PF-status callback.
* AFTER_REFRESH also covers its first display. Do not resize header grids.
    IF im_body_fit_active <> 'X' OR im_body_fit_busy = 'X'. RETURN. ENDIF.
    IF sender = im_head_grid_a OR sender = im_head_grid_b. RETURN. ENDIF.
    CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
      IMPORTING e_grid = lo_current.
    IF lo_current IS INITIAL OR sender <> lo_current. RETURN. ENDIF.
    im_body_fit_busy = 'X'.
    PERFORM im_body_fit USING sender.
    IF im_screen_mode = 'M' OR im_screen_mode = 'D'.
      IF im_toolbar_grid <> sender.
        im_toolbar_grid = sender.
        CALL METHOD sender->set_toolbar_interactive.
      ENDIF.
    ENDIF.
    CLEAR im_body_fit_busy.
  ENDMETHOD.
  METHOD toolbar.
    DATA: ls_button TYPE stb_button, ls_link TYPE im_function_link.
    IF sender = im_head_grid_a OR sender = im_head_grid_b. RETURN. ENDIF.
    DELETE e_object->mt_toolbar WHERE function = 'ZJSON' OR function = 'ZPROOF' OR
      function = 'ZSAVE' OR function = 'ZWA_LOG'.
    IF wa_top_bar IS NOT INITIAL. RETURN. ENDIF.
    IF im_screen_mode = 'M'.
      ls_button-function = 'ZJSON'. ls_button-text = 'JSON 다운로드'.
      ls_button-quickinfo = '조회조건 적용 전 전체 진단 결과를 UTF-8 JSON으로 저장'.
    ELSEIF im_screen_mode = 'D'.
      PERFORM im_link_get USING im_view_result-path CHANGING ls_link.
      IF ls_link-api_path IS INITIAL. RETURN. ENDIF.
      ls_button-function = 'ZPROOF'. ls_button-text = '활성 소스 대조'.
      ls_button-quickinfo = '현재 SAP 함수 API 소스와 활성 Include를 직접 비교'.
    ELSE. RETURN. ENDIF.
    INSERT ls_button INTO e_object->mt_toolbar INDEX 1.
    PERFORM wa_toolbar USING e_object.
  ENDMETHOD.
  METHOD command.
    DATA lo_current TYPE REF TO cl_gui_alv_grid.
    CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR' IMPORTING e_grid = lo_current.
    IF lo_current <> sender. RETURN. ENDIF.
    IF im_screen_mode = 'M' AND e_ucomm = 'ZSAVE'.
      PERFORM wa_apply USING sender.
    ELSEIF im_screen_mode = 'M' AND e_ucomm = 'ZWA_LOG'.
      PERFORM wa_log_download.
    ELSEIF im_screen_mode = 'M' AND e_ucomm = 'ZJSON'.
      PERFORM im_json_download.
    ELSEIF im_screen_mode = 'D' AND e_ucomm = 'ZPROOF'.
      PERFORM im_proof_grid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

INITIALIZATION.
  c_pkgm = '개발 패키지'. c_bspm = 'BSP 애플리케이션'.
  c_bsp = 'BSP 애플리케이션 이름'.
  c_scope = '진단 대상'. c_input = '추출본 파일'.
  c_extra = '추가선택(결과유형)'.
  c_all = '전체'. c_src = 'ABAP 소스'. c_xml = 'XML'. c_mime = '웹자산(HTML·JS·CSS·MIME)'.
  c_task = '웹자산 CTS 작업(요청 하위)'.
  c_pack = '개발클래스(하위 포함)'.
  c_file = '비교할 추출본'.
  c_diff = '신규/누락/수정만 조회'.
  gv_language_init = sy-langu.
  s_lang-sign = 'I'. s_lang-option = 'EQ'. s_lang-low = 'KO'.
  APPEND s_lang.
AT SELECTION-SCREEN OUTPUT.
  PERFORM scope_mode.
  PERFORM scope_screen.
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM im_choose CHANGING p_file.
AT SELECTION-SCREEN ON p_pack.
  IF p_pkgm = 'X' AND p_pack IS NOT INITIAL AND sy-ucomm = 'ONLI'.
    SELECT SINGLE devclass FROM tdevc INTO tdevc-devclass
      WHERE devclass = p_pack.
    IF sy-subrc <> 0.
      MESSAGE '존재하는 개발클래스 하나를 입력하세요. 예: ZHR5' TYPE 'E'.
    ENDIF.
  ENDIF.
AT SELECTION-SCREEN.
  PERFORM scope_mode.
  IF sy-ucomm = 'ONLI' AND p_bspr IS INITIAL.
    PERFORM scope_selection CHANGING gv_error.
    IF gv_error IS NOT INITIAL. MESSAGE gv_error TYPE 'E'. ENDIF.
  ENDIF.
START-OF-SELECTION.
  IF p_bspr = 'X'.
    PERFORM wa_bsp_probe.
    RETURN.
  ENDIF.
  PERFORM im_reset.
  im_program = sy-repid.
  im_started_date = sy-datum. im_started_time = sy-uzeit.
  gv_language_start = sy-langu.
  PERFORM scope_mode.
  PERFORM scope_selection CHANGING gv_fatal.
  IF gv_fatal IS NOT INITIAL. PERFORM im_stop USING 'SCOPE' gv_fatal. RETURN. ENDIF.
  gv_maxbytes = p_mb * 1024 * 1024.
  IF sy-batch = 'X'.
    WRITE / 'STOP: run interactively in SAP GUI.'. RETURN.
  ENDIF.
  TRY.
      PERFORM im_progress USING '사전 점검' 0 0 space.
      PERFORM preflight.
      IF gv_fatal IS INITIAL. PERFORM im_init. ENDIF.
      IF gv_fatal IS INITIAL.
        PERFORM im_upload USING p_file
          CHANGING im_zip_b im_entries_b.
      ENDIF.
      IF gv_fatal IS INITIAL. PERFORM im_read_manifest. ENDIF.
      IF gv_fatal IS INITIAL.
        PERFORM im_progress USING '패키지·객체 검색' 0 0 space.
        PERFORM discover.
        IF gv_fatal IS INITIAL AND p_bspm = 'X'.
          IF gv_scope_package <> im_header-bsp_package.
            gv_fatal = 'BSP 소유 패키지가 추출 이후 변경되었습니다. 다시 추출하십시오.'.
          ELSE. p_pack = gv_scope_package.
          ENDIF.
        ENDIF.
      ENDIF.
      IF gv_fatal IS INITIAL. PERFORM im_snapshot. ENDIF.
      IF gv_fatal IS INITIAL AND p_bspm <> 'X'. PERFORM im_confirm_function_sources. ENDIF.
      IF gv_fatal IS INITIAL. PERFORM im_compare. ENDIF.
      IF gv_fatal IS INITIAL AND p_bspm <> 'X'.
        PERFORM im_progress USING 'ABAP 문법 검사 준비' 0 0 space.
        PERFORM im_prepare_sources.
        PERFORM im_syntax_units.
        PERFORM im_apply_checks.
      ENDIF.
      IF gv_fatal IS NOT INITIAL.
        PERFORM im_stop USING gv_stage gv_fatal. RETURN.
      ENDIF.
      GET TIME.
      im_finished_date = sy-datum. im_finished_time = sy-uzeit.
      PERFORM wa_prepare.
      PERFORM im_filter_results.
      PERFORM im_progress USING '진단 완료' 1 1 '결과 화면 준비'.
      PERFORM im_show.
    CATCH cx_root INTO go_error.
      CLEAR: im_body_fit_active, im_body_fit_busy.
      SET HANDLER lcl_im_alv_fit=>after_refresh lcl_im_alv_fit=>toolbar
    lcl_im_alv_fit=>command FOR ALL INSTANCES ACTIVATION space.
      gv_error = go_error->get_text( ).
      PERFORM im_stop USING gv_stage gv_error.
  ENDTRY.

FORM im_reset.
  DATA lv_release_error TYPE string.
  FIELD-SYMBOLS <ls_wa_locked> TYPE wa_target.
* Do not lose a lock handle when the selection screen is executed again.
  LOOP AT wa_targets ASSIGNING <ls_wa_locked> WHERE locked = 'X'.
    PERFORM wa_lock USING space CHANGING <ls_wa_locked> lv_release_error.
    IF lv_release_error IS NOT INITIAL.
      MESSAGE lv_release_error TYPE 'I'. LEAVE PROGRAM.
    ENDIF.
  ENDLOOP.
  FREE: wa_targets, wa_assets_a, wa_meta_a, wa_events, wa_bsp_apps.
  CLEAR: wa_busy, wa_touched, wa_backup, wa_journal, wa_catalog_error,
         wa_journal_owned, wa_run, wa_log_error.
  CLEAR: im_body_fit_active, im_body_fit_busy, im_screen_mode, im_toolbar_grid.
  SET HANDLER lcl_im_alv_fit=>after_refresh lcl_im_alv_fit=>toolbar
    lcl_im_alv_fit=>command FOR ALL INSTANCES ACTIVATION space.
  PERFORM im_header_free.
  FREE: im_history, im_head_compare, im_head_verify, im_head_detail_a, im_head_detail_b, im_absence.
* Re-running from the selection screen must not reuse a prior ZIP/snapshot.
  FREE: im_zip_b, go_zip, gr_new_source, go_error,
        im_entries_b, im_manifest,
        im_manifest_index, im_packages,
        im_current, im_current_index, im_results, im_sources, im_function_proofs,
        im_tab_proofs, im_function_links, im_all_results,
        im_checks, im_stack, im_fcat, im_view,
        gt_mime_metadata, gt_web_assets, gt_web_refs,
        gt_packages, gt_seen_pkg, gt_objects, gt_files, gt_refs,
        gt_logs, gt_paths, gt_done_smim, gt_scanned, gt_owners,
        gt_include_queue, gt_queued, gt_fugr_mains,
        gt_owner_api_meta, gt_new_api_meta.
  CLEAR: gv_scope_package, gv_bsp_flat, im_header, im_layout, im_baseline_mode, im_view_limited, im_view_group,
         im_view_result, im_view_bytes_a, im_view_bytes_b, im_view_bytes_c,
         im_started_date, im_started_time, im_finished_date, im_finished_time,
         im_count, im_total_results, im_filter_label, im_units, im_cr, im_crlf,
         im_interface_prepared, im_interface_ready, im_interface_error,
         im_progress_stage, im_progress_done, im_progress_total,
         im_progress_date, im_progress_time, im_progress_sent,
         gs_package, gs_object, gs_header,
         gv_owner_prepared, gv_owner_ready, gv_owner_reason,
         gv_fm_prepared, gv_function_api, gv_api_reason,
         gv_file_language, gv_check_mode, gv_payload_state,
         gv_language_ko, gv_language_en,
         gv_root, gv_archive_name, gv_fatal, gv_bytes, gv_lf, gv_tab,
         gv_component, gv_stage, gv_count, gv_index, gv_zip,
         gv_error, gv_ok.
ENDFORM.

FORM im_choose CHANGING cv_file TYPE c.
  DATA: lt_files TYPE filetable, ls_file TYPE file_table, lv_rc TYPE i.
  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING window_title = '진단할 추출본 ZIP 선택'
      default_extension = 'zip' file_filter = 'ZIP (*.zip)|*.zip|'
    CHANGING file_table = lt_files rc = lv_rc
    EXCEPTIONS OTHERS = 1.
  IF sy-subrc = 0 AND lv_rc > 0.
    READ TABLE lt_files INTO ls_file INDEX 1.
    cv_file = ls_file-filename.
  ENDIF.
ENDFORM.

FORM im_init.
  DATA: lo_in TYPE REF TO cl_abap_conv_in_ce, lv_raw TYPE xstring.
  lv_raw = '0D'.
  CALL METHOD cl_abap_conv_in_ce=>create
    EXPORTING encoding = 'UTF-8' input = lv_raw
    RECEIVING conv = lo_in.
  CALL METHOD lo_in->read IMPORTING data = im_cr.
  CONCATENATE im_cr gv_lf INTO im_crlf.
  PERFORM im_selftest.
ENDFORM.

FORM im_safe_path USING pv_path TYPE string CHANGING cv_error TYPE string.
  DATA: lt_parts TYPE ty_lines, lv_part TYPE string, lv_n TYPE i, lv_char TYPE c.
  CLEAR cv_error.
  lv_n = strlen( pv_path ).
  IF lv_n = 0 OR lv_n > 512.
    cv_error = 'Empty path or path exceeds 512 characters'. RETURN.
  ENDIF.
  lv_n = lv_n - 1.
  IF pv_path(1) = '/' OR pv_path+lv_n(1) = '/' OR
     pv_path CS '\' OR pv_path CS ':'.
    cv_error = 'Absolute/drive/backslash path is not allowed'. RETURN.
  ENDIF.
  FIND REGEX '[[:cntrl:]]' IN pv_path.
  IF sy-subrc = 0.
    cv_error = 'Control character in ZIP path'. RETURN.
  ENDIF.
  SPLIT pv_path AT '/' INTO TABLE lt_parts.
  LOOP AT lt_parts INTO lv_part.
    IF lv_part IS INITIAL OR lv_part = '.' OR lv_part = '..'.
      cv_error = 'Empty/dot/traversal path segment'. RETURN.
    ENDIF.
    lv_n = strlen( lv_part ) - 1.
    lv_char = lv_part+lv_n(1).
    IF lv_char = space OR lv_char = '.'.
      cv_error = 'Trailing dot/space in path segment'. RETURN.
    ENDIF.
  ENDLOOP.
ENDFORM.

FORM im_stop USING pv_stage TYPE csequence pv_error TYPE string.
* Long ZIP paths must remain visible in the classic 255-column list.
  DATA: lv_text TYPE string, lv_chunk TYPE c LENGTH 220,
        lv_length TYPE i, lv_take TYPE i.
  WRITE: / 'STOP:', pv_stage.
  lv_text = pv_error. lv_length = strlen( lv_text ).
  WHILE lv_length > 0.
    lv_take = lv_length. IF lv_take > 220. lv_take = 220. ENDIF.
    lv_chunk = lv_text(lv_take). WRITE / lv_chunk.
    lv_text = lv_text+lv_take. lv_length = strlen( lv_text ).
  ENDWHILE.
  IF wa_touched IS INITIAL.
    WRITE / 'SAP 저장소 변경은 수행하지 않았습니다.'.
  ELSE.
    WRITE / '반영 호출 이력이 있습니다. 백업과 실행 로그를 확인하십시오.'.
  ENDIF.
ENDFORM.

FORM im_entry_limit USING pv_count TYPE i pv_size TYPE i pv_name TYPE string
                    CHANGING cv_error TYPE string.
  DATA: lv_count TYPE c LENGTH 20, lv_size TYPE c LENGTH 20.
  CLEAR cv_error.
  WRITE pv_count TO lv_count NO-GROUPING. CONDENSE lv_count.
  WRITE pv_size TO lv_size NO-GROUPING. CONDENSE lv_size.
  IF pv_count > 100000.
    CONCATENATE 'ZIP_ENTRY_COUNT_LIMIT: 전체 항목 수=' lv_count
      ' / 허용=100000 (폴더와 baseline 사본 포함)' INTO cv_error.
  ELSEIF pv_size < 0.
    CONCATENATE 'ZIP_INVALID_ENTRY_SIZE: 음수 용량(bytes)=' lv_size
      ' / ZIP 헤더 또는 지원 형식을 확인하십시오. 파일=' pv_name INTO cv_error.
  ELSEIF pv_size > 16777216.
    CONCATENATE 'ZIP_ENTRY_SIZE_LIMIT: 압축 해제 후 개별 파일 용량(bytes)=' lv_size
      ' / 허용=16777216 (16 MiB) / 파일=' pv_name INTO cv_error.
  ENDIF.
ENDFORM.

FORM im_upload USING pv_file TYPE c
               CHANGING co_zip TYPE REF TO cl_abap_zip
                        ct_entries TYPE im_entries.
  DATA: lt_binary TYPE ty_binary, lv_file TYPE string,
        lv_length TYPE i, lv_zip TYPE xstring,
        lv_actual TYPE c LENGTH 20,
        lv_limit TYPE c LENGTH 20.
  gv_stage = 'UPLOAD_ZIP'.
  PERFORM im_progress USING '추출본 읽기' 0 0 pv_file.
  lv_file = pv_file.
  CALL METHOD cl_gui_frontend_services=>gui_upload
    EXPORTING filename = lv_file filetype = 'BIN'
    IMPORTING filelength = lv_length
    CHANGING data_tab = lt_binary
    EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0 OR lv_length <= 0.
    gv_fatal = 'ZIP upload failed or was cancelled'. RETURN.
  ENDIF.
  IF lv_length > gv_maxbytes.
    WRITE lv_length TO lv_actual NO-GROUPING. CONDENSE lv_actual.
    WRITE gv_maxbytes TO lv_limit NO-GROUPING. CONDENSE lv_limit.
    CONCATENATE 'ZIP_COMPRESSED_LIMIT: ZIP 용량(bytes)=' lv_actual
      ' / 허용(bytes)=' lv_limit INTO gv_fatal. RETURN.
  ENDIF.
  CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
    EXPORTING input_length = lv_length
    IMPORTING buffer = lv_zip
    TABLES binary_tab = lt_binary
    EXCEPTIONS failed = 1 OTHERS = 2.
  IF sy-subrc <> 0.
    gv_fatal = 'Binary ZIP conversion failed'. RETURN.
  ENDIF.
  FREE lt_binary.
  PERFORM create_zip CHANGING co_zip.
  PERFORM im_progress USING '압축파일 열기' 0 0 space.
  CALL METHOD co_zip->load EXPORTING zip = lv_zip
    EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0.
    gv_fatal = 'ZIP LOAD failed: encrypted/ZIP64/invalid ZIP unsupported'.
    RETURN.
  ENDIF.
  CLEAR lv_zip.
  PERFORM im_index_zip USING co_zip CHANGING ct_entries.

ENDFORM.

FORM im_git_metadata USING pv_name TYPE string pv_prefix TYPE string
                     CHANGING cv_ignore TYPE c.
* Only workspace root metadata. A .git segment inside a package asset
* is not silently dropped. Prefix is the verified manifest directory.
  DATA: lv_name TYPE string, lv_n TYPE i.
  CLEAR cv_ignore.
  lv_name = pv_name. TRANSLATE lv_name TO UPPER CASE.
  IF lv_name = '.GIT' OR lv_name CP '.GIT/*'.
    cv_ignore = 'X'. RETURN.
  ENDIF.
  lv_n = strlen( pv_prefix ).
  IF lv_n > 0 AND strlen( pv_name ) > lv_n.
    IF pv_name(lv_n) = pv_prefix.
      lv_name = pv_name+lv_n. TRANSLATE lv_name TO UPPER CASE.
      IF lv_name = '.GIT' OR lv_name CP '.GIT/*'. cv_ignore = 'X'. ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.

FORM im_index_zip USING po_zip TYPE REF TO cl_abap_zip
                  CHANGING ct_entries TYPE im_entries.
  DATA: ls_zip TYPE cl_abap_zip=>t_file, ls_entry TYPE im_entry,
        lt_raw TYPE im_entries, lt_case TYPE im_paths,
        lv_count TYPE i, lv_total TYPE i, lv_manifests TYPE i, lv_progress TYPE i,
        lv_n TYPE i, lv_start TYPE i, lv_skipped TYPE i,
        lv_name TYPE string, lv_key TYPE string, lv_prefix TYPE string,
        lv_error TYPE string, lv_ignore TYPE c, lv_dir TYPE c,
        lv_actual TYPE c LENGTH 20, lv_limit TYPE c LENGTH 20.
  REFRESH ct_entries.
  DESCRIBE TABLE po_zip->files LINES lv_count.
  PERFORM im_entry_limit USING lv_count 0 lv_name CHANGING gv_fatal.
  IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  WRITE: / 'ZIP 전체 항목 수:', lv_count, '(폴더와 baseline 사본 포함)'.
* First resolve the manifest prefix from directory metadata only.
* No GET/decompression is performed here, including for .git pack files.
  PERFORM im_progress USING '압축 항목 검사' 0 lv_count space.
  LOOP AT po_zip->files INTO ls_zip.
    lv_progress = sy-tabix.
    PERFORM im_progress_item USING '압축 항목 검사' lv_progress lv_count ls_zip-name.
    lv_name = ls_zip-name. lv_n = strlen( lv_name ). CLEAR lv_dir.
    IF ls_zip-size < 0.
      PERFORM im_entry_limit USING lv_count ls_zip-size lv_name CHANGING gv_fatal.
      RETURN.
    ENDIF.
    IF lv_n > 0.
      lv_start = lv_n - 1.
      IF lv_name+lv_start(1) = '/'.
        lv_name = lv_name(lv_start). lv_dir = 'X'.
      ENDIF.
    ENDIF.
    PERFORM im_safe_path USING lv_name CHANGING lv_error.
    IF lv_error IS NOT INITIAL.
      CONCATENATE lv_error lv_name INTO gv_fatal SEPARATED BY space. RETURN.
    ENDIF.
    IF lv_dir = 'X'. CONTINUE. ENDIF.
    lv_key = lv_name. TRANSLATE lv_key TO UPPER CASE.
    INSERT lv_key INTO TABLE lt_case.
    IF sy-subrc <> 0.
      gv_fatal = 'Duplicate/case-colliding ZIP entry'. RETURN.
    ENDIF.
    ls_entry-path = lv_name. ls_entry-original = lv_name. ls_entry-size = ls_zip-size.
    INSERT ls_entry INTO TABLE lt_raw.
    IF lv_name = 'manifest.xml' OR lv_name CP '*/manifest.xml'.
* Git-internal files cannot establish an export manifest root.
      IF lv_key CP '.GIT/*' OR lv_key CS '/.GIT/' OR
         lv_key CP '__MACOSX/*'. CONTINUE. ENDIF.
      ADD 1 TO lv_manifests.
      lv_n = strlen( lv_name ) - 12. lv_prefix = lv_name(lv_n).
    ENDIF.
  ENDLOOP.
  IF lv_manifests <> 1.
    gv_fatal = 'ZIP must contain exactly one manifest.xml outside Git metadata'. RETURN.
  ENDIF.
  DESCRIBE TABLE lt_raw LINES lv_count.
  PERFORM im_progress USING '압축 경로 색인' 0 lv_count space.
  LOOP AT lt_raw INTO ls_entry.
    lv_progress = sy-tabix.
    PERFORM im_progress_item USING '압축 경로 색인' lv_progress lv_count ls_entry-path.
    PERFORM im_git_metadata USING ls_entry-path lv_prefix CHANGING lv_ignore.
    IF lv_ignore = 'X'. ADD 1 TO lv_skipped. CONTINUE. ENDIF.
* Limits still apply to every remaining file, including baseline copies.
    PERFORM im_entry_limit USING lv_count ls_entry-size ls_entry-path CHANGING gv_fatal.
    IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
    lv_total = lv_total + ls_entry-size.
    IF lv_total > gv_maxbytes.
      WRITE lv_total TO lv_actual NO-GROUPING. CONDENSE lv_actual.
      WRITE gv_maxbytes TO lv_limit NO-GROUPING. CONDENSE lv_limit.
      CONCATENATE 'ZIP_TOTAL_LIMIT: Git 제외 압축 해제 누적 용량(bytes)=' lv_actual
        ' / 허용(bytes)=' lv_limit ' / 확인 중인 파일=' ls_entry-path INTO gv_fatal. RETURN.
    ENDIF.
    IF ls_entry-path CP '__MACOSX/*'. CONTINUE. ENDIF.
    lv_n = strlen( lv_prefix ).
    IF lv_n > 0.
      IF strlen( ls_entry-path ) <= lv_n. CONTINUE. ENDIF.
      IF ls_entry-path(lv_n) <> lv_prefix. CONTINUE. ENDIF.
      ls_entry-path = ls_entry-path+lv_n.
    ENDIF.
    IF ls_entry-path = '.DS_Store' OR ls_entry-path CP '*/.DS_Store'. CONTINUE. ENDIF.
    INSERT ls_entry INTO TABLE ct_entries.
  ENDLOOP.
  WRITE: / 'SAP 비교에서 제외한 Git 관리 파일:', lv_skipped,
    / '검사 대상 압축 해제 누적 용량(bytes):', lv_total.
ENDFORM.

FORM im_get USING po_zip TYPE REF TO cl_abap_zip
                  pt_entries TYPE im_entries pv_path TYPE string
            CHANGING cv_data TYPE xstring cv_ok TYPE c.
  DATA ls_entry TYPE im_entry.
  CLEAR: cv_data, cv_ok.
  IF po_zip IS INITIAL. RETURN. ENDIF.
  READ TABLE pt_entries INTO ls_entry WITH TABLE KEY path = pv_path.
  IF sy-subrc <> 0. RETURN. ENDIF.
  CALL METHOD po_zip->get EXPORTING name = ls_entry-original
    IMPORTING content = cv_data EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0. CLEAR cv_data. RETURN. ENDIF.
  IF xstrlen( cv_data ) <> ls_entry-size.
    CLEAR cv_data. RETURN.
  ENDIF.
  cv_ok = 'X'.
ENDFORM.

FORM im_decode USING pv_data TYPE xstring
               CHANGING cv_text TYPE string cv_error TYPE string.
  DATA: lo_in TYPE REF TO cl_abap_conv_in_ce, lo_err TYPE REF TO cx_root,
        lv_data TYPE xstring, lv_again TYPE xstring.
  CLEAR: cv_text, cv_error.
  lv_data = pv_data.
  IF xstrlen( lv_data ) >= 3.
    IF lv_data(3) = 'EFBBBF'. lv_data = lv_data+3. ENDIF.
  ENDIF.
  IF lv_data IS INITIAL. RETURN. ENDIF.
  TRY.
      CALL METHOD cl_abap_conv_in_ce=>create
        EXPORTING encoding = 'UTF-8' input = lv_data ignore_cerr = ' '
        RECEIVING conv = lo_in.
      CALL METHOD lo_in->read IMPORTING data = cv_text.
      PERFORM utf8 USING cv_text CHANGING lv_again.
      IF lv_again <> lv_data.
        cv_error = 'UTF-8 byte round-trip mismatch'.
      ENDIF.
    CATCH cx_root INTO lo_err.
      cv_error = lo_err->get_text( ).
  ENDTRY.
ENDFORM.

FORM im_xml USING pv_data TYPE xstring CHANGING cv_error TYPE string.
  DATA lo_doc TYPE REF TO if_ixml_document.
  PERFORM im_xml_document USING pv_data CHANGING lo_doc cv_error.
ENDFORM.

FORM im_xml_document USING pv_data TYPE xstring
                     CHANGING co_doc TYPE REF TO if_ixml_document cv_error TYPE string.
  DATA: lo_ixml TYPE REF TO if_ixml,
        lo_sf TYPE REF TO if_ixml_stream_factory,
        lo_in TYPE REF TO if_ixml_istream,
        lo_doc TYPE REF TO if_ixml_document,
        lo_parser TYPE REF TO if_ixml_parser,
        lo_parse_error TYPE REF TO if_ixml_parse_error,
        lv_text TYPE string, lv_upper TYPE string, lv_rc TYPE i.
  CLEAR: co_doc, cv_error.
  PERFORM im_decode USING pv_data CHANGING lv_text cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  lv_upper = lv_text. TRANSLATE lv_upper TO UPPER CASE.
  IF lv_upper CS '<!DOCTYPE' OR lv_upper CS '<!ENTITY'.
    cv_error = 'DTD/ENTITY declarations are not accepted'. RETURN.
  ENDIF.
  lo_ixml = cl_ixml=>create( ).
  lo_sf = lo_ixml->create_stream_factory( ).
  lo_doc = lo_ixml->create_document( ).
  lo_in = lo_sf->create_istream_xstring( string = pv_data ).
  lo_parser = lo_ixml->create_parser( stream_factory = lo_sf
    istream = lo_in document = lo_doc ).
  lv_rc = lo_parser->parse( ).
  IF lv_rc <> 0.
    cv_error = 'XML is not well-formed'.
    lo_parse_error = lo_parser->get_error( index = 0 ).
    IF lo_parse_error IS NOT INITIAL.
      cv_error = lo_parse_error->get_reason( ).
    ENDIF.
  ELSE.
    co_doc = lo_doc.
  ENDIF.
ENDFORM.

FORM im_manifest_compat USING ps_header TYPE ty_header
                        CHANGING cv_error TYPE string.
* The layout is selected from a validated header, never from a filename.
  CLEAR: cv_error, gv_bsp_flat.
  IF ps_header-format <> 'DEVHUB-EXPORT'.
    cv_error = 'MANIFEST_FORMAT_UNSUPPORTED'. RETURN.
  ENDIF.
  IF ps_header-version = '0.2' AND
     ( ps_header-tool_version = '0.3.18' OR ps_header-tool_version = '0.3.28' ).
    IF ps_header-scope_kind IS NOT INITIAL OR ps_header-bsp_application IS NOT INITIAL OR
       ps_header-bsp_package IS NOT INITIAL OR ps_header-path_layout IS NOT INITIAL.
      cv_error = 'LEGACY_SCOPE_INVALID: 기존 ZIP에 BSP 범위를 추가할 수 없습니다.'.
    ELSEIF p_bspm = 'X'.
      cv_error = '이 ZIP은 기존 패키지 추출본입니다. 개발 패키지 모드를 사용하십시오.'.
    ENDIF.
    RETURN.
  ENDIF.
  IF ps_header-version = '0.4' AND ps_header-tool_version = '0.4.1' AND
     ps_header-scope_kind = 'BSP' AND ps_header-path_layout = 'BSP_APP_ROOT'.
* New BSP-only layout. The mode/app identity is checked below.
  ELSEIF ps_header-version = '0.3' AND ps_header-path_layout IS INITIAL AND
         ( ps_header-tool_version = '0.4.0' OR
           ( ps_header-tool_version = '0.4.1' AND ps_header-scope_kind = 'PACKAGE' ) ).
* Original package paths, including the previously exported BSP archives.
  ELSE.
    cv_error = 'EXPORT_VERSION_UNSUPPORTED: 지원 Export=0.3.18/0.3.28/0.4.0/0.4.1; manifest를 직접 바꾸지 마십시오.'.
    RETURN.
  ENDIF.
  IF p_bspm = 'X'.
    IF ps_header-scope_kind <> 'BSP' OR ps_header-bsp_application <> p_bsp OR
       ps_header-bsp_package IS INITIAL.
      cv_error = 'BSP_SCOPE_MISMATCH: 선택한 BSP 이름과 ZIP의 추출 범위가 다릅니다.'.
    ENDIF.
  ELSEIF ps_header-scope_kind <> 'PACKAGE' OR
         ps_header-bsp_application IS NOT INITIAL OR ps_header-bsp_package IS NOT INITIAL.
    cv_error = 'SCOPE_MISMATCH: BSP 추출본은 BSP 애플리케이션 모드에서 업로드하십시오.'.
  ENDIF.
  IF cv_error IS INITIAL AND ps_header-path_layout = 'BSP_APP_ROOT'.
    gv_bsp_flat = 'X'.
  ENDIF.
ENDFORM.

FORM im_read_manifest.
  DATA: lv_data TYPE xstring, lv_ok TYPE c, lv_path TYPE string,
        lv_error TYPE string, ls_file TYPE ty_file, lv_expected TYPE string,
        ls_other TYPE ty_file, lt_cases TYPE im_paths,
        lv_key TYPE string, lo_err TYPE REF TO cx_root.
  gv_stage = 'MANIFEST'.
  PERFORM im_progress USING '원본 목록 검증' 0 0 space. lv_path = 'manifest.xml'.
  PERFORM im_get USING im_zip_b im_entries_b lv_path
    CHANGING lv_data lv_ok.
  IF lv_ok IS INITIAL. gv_fatal = 'ZIP manifest unreadable'. RETURN. ENDIF.
  PERFORM im_xml USING lv_data CHANGING lv_error.
  IF lv_error IS NOT INITIAL. gv_fatal = lv_error. RETURN. ENDIF.
  TRY.
      CALL TRANSFORMATION id SOURCE XML lv_data
        RESULT header = im_header packages = im_packages
               files = im_manifest.
    CATCH cx_root INTO lo_err.
      gv_fatal = lo_err->get_text( ). RETURN.
  ENDTRY.
  WRITE: / 'ZIP manifest FORMAT:', im_header-format,
    / 'ZIP manifest VERSION:', im_header-version,
    / 'ZIP Export 프로그램 버전:', im_header-tool_version.
  PERFORM im_manifest_compat USING im_header CHANGING gv_fatal.
  IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  IF im_header-basis <> '700' OR im_header-unicode <> 'X' OR
     im_header-sysid <> sy-sysid OR im_header-client <> sy-mandt.
    gv_fatal = 'ZIP must originate from this SAP SID/client, BASIS 700 Unicode'.
    RETURN.
  ENDIF.
  IF im_manifest IS INITIAL OR im_packages IS INITIAL.
    gv_fatal = 'Manifest FILES/PACKAGES is empty'. RETURN.
  ENDIF.
  SORT im_manifest BY path.
  SORT im_packages BY devclass.
  LOOP AT im_manifest INTO ls_file.
    PERFORM im_progress_pulse USING ls_file-path.
    PERFORM im_safe_path USING ls_file-path CHANGING lv_error.
    CONCATENATE '.devhub/baseline/' ls_file-path INTO lv_expected.
    IF lv_error IS NOT INITIAL OR ls_file-baseline <> lv_expected OR
       strlen( ls_file-path ) > 220 OR
       ls_file-byte_length < 0 OR ls_file-byte_length > 16777216 OR
       ls_file-checksum_algorithm <> 'CRC32-SIGNED-INT32' OR
       ( ls_file-check_mode <> 'LF_UTF8' AND ls_file-check_mode <> 'RAW' ).
      gv_fatal = 'Invalid manifest path/baseline/size/checksum/check mode'.
      RETURN.
    ENDIF.
    PERFORM im_payload_path USING ls_file-path CHANGING lv_ok.
    IF lv_ok IS INITIAL.
      gv_fatal = 'Unknown manifest payload root'. RETURN.
    ENDIF.
    lv_key = ls_file-path. TRANSLATE lv_key TO UPPER CASE.
    INSERT lv_key INTO TABLE lt_cases.
    IF sy-subrc <> 0.
      gv_fatal = 'Duplicate/case-colliding manifest path'. RETURN.
    ENDIF.
    INSERT ls_file INTO TABLE im_manifest_index.
  ENDLOOP.
  PERFORM im_scope_manifest CHANGING gv_fatal.
  IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  im_baseline_mode = 'EMBEDDED_CRC_LENGTH'.
ENDFORM.

FORM im_snapshot.
  DATA: ls_meta TYPE ty_file, lv_total TYPE i.
  gv_stage = 'READ_CURRENT_SAP'.
  DESCRIBE TABLE gt_objects LINES lv_total.
  PERFORM im_progress USING '현재 SAP 객체 조회' 0 lv_total space.
  LOOP AT gt_objects INTO gs_object.
    gv_index = sy-tabix.
    PERFORM im_progress_item USING '현재 SAP 객체 조회' gv_index lv_total gs_object-obj_name.
    CLEAR: gv_file_language, gv_root, gv_stage, gv_component,
           gv_payload_state, gv_check_mode.
    IF gs_object-pgmid = 'R3TR'.
      TRY.
          PERFORM export_object.
        CATCH cx_root INTO go_error.
          PERFORM object_error USING go_error.
      ENDTRY.
    ENDIF.
    MODIFY gt_objects FROM gs_object INDEX gv_index.
    IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.

  ENDLOOP.
  PERFORM im_progress USING '현재 SAP 목록 정리' 0 0 space.
  PERFORM finalize_mime.
  PERFORM finalize_web.
  LOOP AT gt_files INTO ls_meta.
    INSERT ls_meta INTO TABLE im_current_index.
    IF sy-subrc <> 0.
      gv_fatal = 'Duplicate live serializer path'. RETURN.
    ENDIF.
  ENDLOOP.
ENDFORM.


FORM im_triplet USING ps_file TYPE ty_file
                CHANGING cv_a TYPE xstring cv_b TYPE xstring
                         cv_c TYPE xstring cv_aok TYPE c
                         cv_bok TYPE c cv_cok TYPE c.
  DATA: lv_crc TYPE i, ls_blob TYPE im_blob.
  CLEAR: cv_a, cv_b, cv_c, cv_aok, cv_bok, cv_cok.
  PERFORM im_get USING im_zip_b im_entries_b ps_file-baseline
    CHANGING cv_a cv_aok.
  IF cv_aok = 'X'.
    CALL METHOD cl_abap_zip=>crc32 EXPORTING content = cv_a
      RECEIVING crc32 = lv_crc.
    IF lv_crc <> ps_file-checksum OR
       xstrlen( cv_a ) <> ps_file-byte_length.
      CLEAR cv_aok.
    ENDIF.
  ENDIF.
  PERFORM im_get USING im_zip_b im_entries_b ps_file-path
    CHANGING cv_b cv_bok.
  READ TABLE im_current INTO ls_blob WITH TABLE KEY path = ps_file-path.
  IF sy-subrc = 0. cv_c = ls_blob-data. cv_cok = 'X'. ENDIF.
ENDFORM.

FORM im_format_note USING pv_a TYPE xstring pv_b TYPE xstring
                    CHANGING cv_note TYPE csequence.
  DATA: lv_a TYPE string, lv_b TYPE string, lv_error TYPE string.
  CLEAR cv_note.
  IF pv_a = pv_b. RETURN. ENDIF.
  PERFORM im_decode USING pv_a CHANGING lv_a lv_error.
  IF lv_error IS NOT INITIAL. RETURN. ENDIF.
  PERFORM im_decode USING pv_b CHANGING lv_b lv_error.
  IF lv_error IS NOT INITIAL. RETURN. ENDIF.
  REPLACE ALL OCCURRENCES OF im_crlf IN lv_a WITH gv_lf.
  REPLACE ALL OCCURRENCES OF im_cr IN lv_a WITH gv_lf.
  REPLACE ALL OCCURRENCES OF im_crlf IN lv_b WITH gv_lf.
  REPLACE ALL OCCURRENCES OF im_cr IN lv_b WITH gv_lf.
  IF lv_a = lv_b. cv_note = 'EOL_OR_BOM_ONLY'. ENDIF.
ENDFORM.

FORM im_validate_file USING ps_file TYPE ty_file pv_b TYPE xstring
                      CHANGING cs_result TYPE im_result.
  DATA: lv_path TYPE string, lv_text TYPE string, lv_error TYPE string,
        lv_text_file TYPE c.
  lv_path = ps_file-path. TRANSLATE lv_path TO LOWER CASE.
  IF lv_path CP '*.xml'.
    PERFORM im_xml USING pv_b CHANGING lv_error.
    IF lv_error IS NOT INITIAL.
      cs_result-validation = 'XML_ERROR'. cs_result-light = '1'.
      cs_result-message = lv_error.
    ELSE.
      cs_result-validation = 'XML_WELL_FORMED_ONLY'.
      cs_result-message = 'XML 문서의 기본 문법을 확인했습니다.'.
    ENDIF.
    RETURN.
  ENDIF.
  IF lv_path CP '*.abap' OR lv_path CP '*.js' OR lv_path CP '*.css'
     OR lv_path CP '*.htm' OR lv_path CP '*.html'.
    lv_text_file = 'X'.
  ENDIF.
  IF lv_text_file IS INITIAL.
    cs_result-validation = 'BINARY_REVIEW'.
    cs_result-message = '바이너리 파일입니다. 내용 일치 열은 전체 바이트 비교이며 이미지의 시각적 변경은 분석하지 않습니다.'.
    RETURN.
  ENDIF.
  PERFORM im_decode USING pv_b CHANGING lv_text lv_error.
  IF lv_error IS NOT INITIAL.
    cs_result-validation = 'ENCODING_REVIEW'.
    cs_result-message = 'UTF-8로 손실 없이 읽을 수 없어 텍스트·문법 검사를 생략했습니다.'.
    cs_result-light = '2'. RETURN.
  ENDIF.
  IF lv_path CP '*.abap'.
    IF ps_file-object = 'PROG' OR ps_file-object = 'FUGR'.
      cs_result-validation = 'CONTEXT_REQUIRED'.
      cs_result-message = '전체 주프로그램 문맥을 확인해야 문법 검사가 가능합니다.'.
    ELSE.
      cs_result-validation = 'BSP_CONTEXT_REQUIRED'.
      cs_result-message = 'UTF-8은 확인했습니다. BSP 생성 프로그램 문맥이 없어 ABAP 문법 검사는 보류했습니다.'.
    ENDIF.
  ELSE.
    cs_result-validation = 'TEXT_ONLY_NOT_SYNTAX'.
    cs_result-message = 'UTF-8은 확인했습니다. HTML·JS·CSS 문법 및 브라우저 실행은 검사하지 않았습니다.'.
  ENDIF.
ENDFORM.

FORM im_compare_values USING pv_base TYPE xstring pv_zip TYPE xstring
                             pv_sap TYPE xstring pv_base_ok TYPE c
                             pv_zip_ok TYPE c pv_sap_ok TYPE c
                       CHANGING cv_zip_change TYPE c
                                cv_sap_change TYPE c cv_match TYPE c.
* Full byte-content equality, not a size/hash-only comparison.
  cv_zip_change = 'NO_BASELINE'. cv_sap_change = 'NO_BASELINE'.
  IF pv_base_ok = 'X'.
    cv_zip_change = 'UNCHANGED'. cv_sap_change = 'UNCHANGED'.
    IF pv_base <> pv_zip. cv_zip_change = 'CHANGED'. ENDIF.
    IF pv_base <> pv_sap. cv_sap_change = 'CHANGED'. ENDIF.
  ENDIF.
  IF pv_zip_ok IS INITIAL. cv_zip_change = 'ZIP_UNREADABLE'. ENDIF.
  IF pv_sap_ok IS INITIAL. cv_sap_change = 'SAP_UNREADABLE'. ENDIF.
  cv_match = 'CANNOT_COMPARE'.
  IF pv_zip_ok = 'X' AND pv_sap_ok = 'X'.
    cv_match = 'IDENTICAL'.
    IF pv_zip <> pv_sap. cv_match = 'DIFFERENT'. ENDIF.
  ENDIF.
ENDFORM.

FORM im_read_state USING ps_file TYPE ty_file
                  CHANGING cv_state TYPE c cv_note TYPE csequence
                           cv_version TYPE c cv_version_note TYPE csequence.
* Called only for a file produced by this run's SAP reader. Never infer
* active/inactive from content equality, XML extension or inherited A.
  DATA ls_proof TYPE im_version_proof.
  cv_state = 'READ_OK'.
  cv_note = '현재 SAP 내용을 읽어 비교용 파일을 생성했습니다.'.
  cv_version = 'VER_NOT_IMPLEMENTED'.
  cv_version_note = '이 구성요소의 활성 버전을 별도로 확인하는 기능이 구현되어 있지 않습니다.'.
  CASE ps_file-component.
    WHEN 'DDIC_STATE_DIAGNOSTIC'.
      cv_state = 'READ_DIAGNOSTIC'.
      cv_note = 'DDIC 정의 조회에 실패하여 DD02L 상태 행으로 진단 파일을 생성했습니다.'.
      cv_version = 'VER_ATTEMPT_FAILED'.
      cv_version_note = 'DDIF API에서 활성 정의를 요청했으나 정상 결과를 얻지 못했습니다. 비활성으로 판정한 것은 아닙니다.'.
      RETURN.
    WHEN 'INCLUDE_SCAN_DIAGNOSTIC'.
      cv_state = 'READ_DIAGNOSTIC'.
      cv_note = '읽은 소스의 Include 관계 분석에서 처리하지 못한 구문을 진단 파일로 기록했습니다.'.
      cv_version = 'VER_NOT_APPLICABLE'.
      cv_version_note = '프로그램이 만든 분석 진단 파일입니다. 파일 자체는 SAP 활성화 대상이 아닙니다.'.
      RETURN.
    WHEN 'FUNCTION_READ_DIAGNOSTIC'.
      cv_state = 'READ_DIAGNOSTIC'.
      cv_note = '함수 API에서 정상 소스를 얻지 못해 조회 오류 진단 파일을 생성했습니다.'.
      cv_version = 'VER_NOT_RUN'.
      cv_version_note = '함수 소스를 얻지 못하여 활성 Include와의 대조를 수행하지 않았습니다.'.
      RETURN.
    WHEN 'FUNCTION_API_SOURCE'.
      cv_note = '함수 조회 API에서 소스를 읽었습니다.'.
      READ TABLE im_function_proofs INTO ls_proof WITH TABLE KEY path = ps_file-path.
      IF sy-subrc = 0.
        cv_version = ls_proof-state. cv_version_note = ls_proof-note.
      ELSE.
        cv_version = 'VER_NOT_RUN'.
        cv_version_note = '이 파일에 대한 활성 Include 대조 결과가 없습니다. 활성 여부를 판정하지 않았습니다.'.
      ENDIF.
      RETURN.
    WHEN 'FUNCTION_TAB'.
      cv_note = '함수의 속성 또는 입출력·예외 정보를 API와 저장소에서 읽었습니다.'.
      READ TABLE im_tab_proofs INTO ls_proof WITH TABLE KEY path = ps_file-path.
      IF sy-subrc = 0.
        cv_version = ls_proof-state. cv_version_note = ls_proof-note.
      ELSE.
        cv_version = 'VER_NOT_RUN'.
        cv_version_note = '활성 인터페이스 대조 결과가 없습니다. XML 내용 비교 결과와 별개입니다.'.
      ENDIF.
      RETURN.
    WHEN 'TRDIR_CATALOG'.
      cv_note = 'TRDIR에서 현재 프로그램 속성을 읽었습니다.'.
      READ TABLE im_tab_proofs INTO ls_proof WITH TABLE KEY path = ps_file-path.
      IF sy-subrc = 0.
        cv_version = ls_proof-state. cv_version_note = ls_proof-note.
      ELSE.
        cv_version = 'VER_NOT_RUN'.
        cv_version_note = '현재 속성과 활성 소스를 연결한 확인 결과가 없습니다.'.
      ENDIF.
      RETURN.
    WHEN 'MESSAGE_SHORT_TEXTS'.
      cv_note = 'T100에서 현재 메시지 번호와 내용을 읽었습니다.'.
      cv_version_note = '현재 T100 행을 조회했습니다. 메시지 클래스의 활성 버전을 별도로 확인하는 기능은 미구현입니다.'.
      RETURN.
    WHEN 'MIME_CONTENT' OR 'W3MI_CONTENT'.
      cv_note = 'MIME 저장소 내용을 두 번 읽어 바이트가 동일한지 확인했습니다.'.
      cv_version = 'VER_NOT_APPLICABLE'.
      cv_version_note = '이 파일은 MIME 저장소 조회 결과입니다. ABAP 소스의 활성(A) 버전 판정 기준을 적용하지 않습니다.'.
      RETURN.
    WHEN 'FUNCTION_DIRECTORY' OR 'INCLUDE_COMPONENT_CATALOG' OR
         'WEB_CATALOG' OR 'MIME_METADATA' OR 'W3MI_METADATA' OR
         'BSP_PAGE_PATH_MAP'.
      cv_note = '현재 SAP 조회 결과로 목록·경로·메타데이터 파일을 생성했습니다.'.
      cv_version = 'VER_NOT_APPLICABLE'.
      cv_version_note = '조회 결과를 정리한 관리 파일입니다. 파일 자체는 SAP 활성화 대상이 아닙니다.'.
      RETURN.
    WHEN 'BSP_PAGE_INVENTORY'.
      cv_note = '활성 페이지 목록을 요청하여 페이지 목록 파일을 생성했습니다.'.
      cv_version = 'VER_NOT_APPLICABLE'.
      cv_version_note = 'p_version=A로 읽은 목록이지만, 목록 파일 자체는 SAP 활성화 대상이 아닙니다. 개별 페이지 상태와 구분합니다.'.
      RETURN.
  ENDCASE.
  IF ps_file-component CS 'DIAGNOSTIC'.
    cv_state = 'READ_DIAGNOSTIC'.
    cv_note = '조회·분석 과정에서 진단 파일을 생성했습니다. 상세 진단을 확인하십시오.'.
    cv_version = 'VER_NOT_APPLICABLE'.
    cv_version_note = '프로그램이 생성한 진단 파일 자체는 SAP 활성화 대상이 아닙니다.'.
    RETURN.
  ENDIF.
  IF ps_file-active_state <> 'A'. RETURN. ENDIF.
* Only components with an audited, explicit active reader can be proven.
  IF ps_file-component = 'DDIC_DEFINITION'.
    cv_version = 'VER_ACTIVE'.
    cv_version_note = 'DDIF API에 STATE=A를 지정하고 반환된 GOTSTATE=A를 확인했습니다.'.
  ELSEIF ps_file-component = 'TEXTPOOL'.
    cv_version = 'VER_ACTIVE'.
    cv_version_note = 'READ TEXTPOOL에서 STATE A로 조회했습니다. 번역이 없으면 빈 결과를 포함합니다.'.
  ELSEIF ps_file-object = 'WAPA' AND
       ( ps_file-component = 'BSP_ATTRIBUTES' OR
         ps_file-component = 'BSP_LAYOUT' OR
         ps_file-component = 'BSP_EVENT_SOURCE' OR
         ps_file-component = 'BSP_PARAMETERS' OR
         ps_file-component = 'BSP_TYPE_SOURCE' ).
    cv_version = 'VER_ACTIVE'.
    cv_version_note = 'BSP 페이지를 버전 A로 LOAD하고 GET_VERSION=A를 확인한 뒤 내용을 읽었습니다.'.
  ELSEIF ( ps_file-object = 'PROG' OR ps_file-object = 'FUGR' ) AND
       ( ps_file-path CP '*/source/*.abap' OR
         ps_file-path CP '*/Include/*.abap' OR
         ps_file-path CP '*/Inlcude/*.abap' ).
    cv_version = 'VER_ACTIVE'.
    cv_version_note = 'READ REPORT에서 STATE A로 두 번 읽고 소스가 같은지 확인했습니다.'.
  ENDIF.
ENDFORM.

FORM im_document_path USING pv_path TYPE string CHANGING cv_doc TYPE c.
* Applies only to files absent from manifest, never tracked MIME assets.
  DATA lv_path TYPE string.
  CLEAR cv_doc. lv_path = pv_path. TRANSLATE lv_path TO LOWER CASE.
  IF lv_path CP '*.md' OR lv_path CP '*.markdown'. cv_doc = 'X'. ENDIF.
ENDFORM.

FORM im_compare.
  DATA: ls_file TYPE ty_file, ls_live TYPE ty_file,
        ls_result TYPE im_result, ls_entry TYPE im_entry,
        lv_a TYPE xstring, lv_b TYPE xstring, lv_c TYPE xstring,
        lv_aok TYPE c, lv_bok TYPE c, lv_cok TYPE c,
        lv_id TYPE i, lv_scope TYPE c, lv_doc TYPE c,
        lv_total TYPE i, lv_done TYPE i,
        ls_pkg TYPE ty_package, ls_obj TYPE ty_object, ls_blob TYPE im_blob.
  gv_stage = 'COMPARE_ZIP_SAP'.
  DESCRIBE TABLE im_manifest LINES lv_total.
  PERFORM im_progress USING '원본·추출본·SAP 비교' 0 lv_total space.
  LOOP AT im_manifest INTO ls_file.
    lv_done = sy-tabix.
    PERFORM im_progress_item USING '원본·추출본·SAP 비교' lv_done lv_total ls_file-path.
    CLEAR ls_result.
    ADD 1 TO lv_id. ls_result-id = lv_id.
    ls_result-path = ls_file-path. ls_result-component = ls_file-component.
    ls_result-devclass = ls_file-devclass.
    ls_result-object = ls_file-object. ls_result-obj_name = ls_file-obj_name.
    ls_result-light = '2'.
    ls_result-validation = 'NOT_CHECKED'.
    ls_result-read_state = 'READ_EXCLUDED'.
    ls_result-read_note = '범위 또는 객체 매핑 검사에서 제외되어 이 행의 SAP 조회 결과를 채택하지 않았습니다.'.
    ls_result-version_state = 'VER_NOT_RUN'.
    ls_result-version_note = '이 행의 SAP 조회 결과를 채택하지 않아 활성 버전 확인도 수행하지 않았습니다.'.
    CLEAR lv_scope.
    READ TABLE gt_seen_pkg WITH TABLE KEY devclass = ls_file-devclass
      TRANSPORTING NO FIELDS.
    IF sy-subrc = 0. lv_scope = 'X'. ENDIF.
    IF ls_file-path = 'catalog/web-assets.xml'. lv_scope = 'X'. ENDIF.
    IF p_bspm = 'X'.
      PERFORM im_scope_current USING ls_file CHANGING lv_scope.
    ENDIF.
    IF lv_scope IS INITIAL.
      ls_result-comparison = 'OUT_OF_SCOPE'.
      ls_result-message = '선택한 개발클래스 범위 밖의 파일입니다.'.
      IF p_bspm = 'X'. ls_result-message = '선택 BSP의 현재 객체 목록에 없는 파일입니다. 삭제로 단정하거나 저장하지 않습니다.'. ENDIF.
      APPEND ls_result TO im_results. CONTINUE.
    ENDIF.
    IF ls_file-devclass IS NOT INITIAL.
      READ TABLE im_packages INTO ls_pkg
        WITH KEY devclass = ls_file-devclass BINARY SEARCH.
      IF sy-subrc <> 0.
        ls_result-comparison = 'MAPPING_REJECTED'. ls_result-light = '1'.
        ls_result-message = '파일의 개발클래스가 manifest 패키지 목록에 없습니다.'.
        APPEND ls_result TO im_results. CONTINUE.
      ENDIF.
    ENDIF.
    PERFORM im_triplet USING ls_file CHANGING lv_a lv_b lv_c
      lv_aok lv_bok lv_cok.
    ls_result-a_ok = lv_aok. ls_result-b_ok = lv_bok.
    ls_result-c_ok = lv_cok. ls_result-active_a = ls_file-active_state.
    ls_result-bytes_a = xstrlen( lv_a ).
    ls_result-bytes_b = xstrlen( lv_b ).
    ls_result-bytes_c = xstrlen( lv_c ).
    CLEAR ls_live.
    READ TABLE im_current_index INTO ls_live
      WITH TABLE KEY path = ls_file-path.
    IF sy-subrc = 0.
      ls_result-active_c = ls_live-active_state.
      IF ls_live-devclass <> ls_file-devclass OR
         ls_live-object <> ls_file-object OR
         ls_live-obj_name <> ls_file-obj_name OR
         ls_live-component <> ls_file-component OR
         ls_live-check_mode <> ls_file-check_mode.
        ls_result-comparison = 'MAPPING_REJECTED'. ls_result-light = '1'.
        ls_result-message = 'manifest 객체 정보와 SAP 조회 객체 정보가 다릅니다.'.
        APPEND ls_result TO im_results. CONTINUE.
      ENDIF.
    ENDIF.
    PERFORM im_compare_values USING lv_a lv_b lv_c lv_aok lv_bok lv_cok
      CHANGING ls_result-zip_change ls_result-sap_change ls_result-comparison.
    IF lv_cok = 'X'.
      PERFORM im_read_state USING ls_live
        CHANGING ls_result-read_state ls_result-read_note
          ls_result-version_state ls_result-version_note.
    ELSE.
      ls_result-read_state = 'READ_FAILED'.
      ls_result-version_state = 'VER_READ_FAILED'.
      ls_result-version_note = '현재 SAP 내용을 확보하지 못하여 이 파일의 활성 버전임을 확인하지 못했습니다. 조회 실패이며 비활성 판정은 아닙니다.'.
      ls_result-read_note = '현재 SAP 내용을 읽지 못했습니다. 삭제 또는 비활성이라고 단정할 수 없습니다.'.
      READ TABLE gt_objects INTO ls_obj WITH KEY
        devclass = ls_file-devclass object = ls_file-object
        obj_name = ls_file-obj_name.
      IF sy-subrc = 0 AND ls_obj-reason IS NOT INITIAL.
        CONCATENATE '현재 비교용 파일을 확보하지 못했습니다. 상세:' ls_obj-reason
          INTO ls_result-read_note SEPARATED BY space.
        IF ls_obj-status = 'UNSUPPORTED'.
          ls_result-read_state = 'READ_NOT_SUPPORTED'.
          ls_result-read_note = '이 객체 유형의 현재 SAP 내용 조회 기능이 구현되어 있지 않습니다.'.
          ls_result-version_state = 'VER_NOT_RUN'.
          ls_result-version_note = '객체 조회 기능이 없어 활성 버전 확인도 수행하지 않았습니다.'.
        ENDIF.
      ENDIF.
    ENDIF.
    IF lv_bok = 'X' AND lv_cok = 'X'.
      PERFORM im_format_note USING lv_c lv_b CHANGING ls_result-ab_format.
    ENDIF.
    IF ls_result-read_state = 'READ_DIAGNOSTIC'.
      ls_result-validation = 'DIAGNOSTIC_ONLY'.
      ls_result-message = '조회·분석 진단 파일입니다. 진단 내용과 대상 소스의 조회·활성 버전 결과를 구분해 확인하십시오.'.
    ELSEIF lv_bok = 'X'.
      IF lv_cok = 'X' AND lv_b = lv_c.
        ls_result-validation = 'IDENTICAL_NOT_TESTED'.
        ls_result-message = '추출본과 현재 SAP 바이트가 같아 추가 문법 검사를 생략했습니다.'.
        IF ls_result-version_state = 'VER_ACTIVE' AND lv_aok = 'X'.
          ls_result-light = '3'.
        ENDIF.
      ELSE.
* Also checks an unchanged ZIP when SAP alone changed since export.
        PERFORM im_validate_file USING ls_file lv_b CHANGING ls_result.
      ENDIF.
    ELSE.
      ls_result-light = '1'.
      ls_result-message = '추출본 파일이 없거나 읽을 수 없습니다. 삭제 작업으로 해석하지 않습니다.'.
      READ TABLE im_entries_b WITH TABLE KEY path = ls_file-path TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        ls_result-validation = 'NO_EXTRACT_TARGET'.
        ls_result-message = '추출본 파일이 없어 문법·형식 검사 대상이 없습니다. SAP 소스를 대신 검사하지 않으며 삭제 요청도 아닙니다.'.
      ENDIF.
    ENDIF.
    IF ls_result-read_state <> 'READ_DIAGNOSTIC'.
      PERFORM im_xml_compare USING ls_file lv_a lv_b lv_c
        lv_aok lv_bok lv_cok CHANGING ls_result.
    ENDIF.
    PERFORM im_pair_result USING lv_a lv_b lv_c CHANGING ls_result.
    APPEND ls_result TO im_results.
  ENDLOOP.
  PERFORM im_progress USING '추가 파일 확인' 0 0 space.
  LOOP AT im_entries_b INTO ls_entry.
    PERFORM im_payload_path USING ls_entry-path CHANGING lv_scope.
    IF lv_scope IS INITIAL. CONTINUE. ENDIF.
    PERFORM im_progress_pulse USING ls_entry-path.
    READ TABLE im_manifest_index WITH TABLE KEY path = ls_entry-path
      TRANSPORTING NO FIELDS.
    IF sy-subrc = 0. CONTINUE. ENDIF.
    CLEAR ls_result. ADD 1 TO lv_id. ls_result-id = lv_id.
    ls_result-path = ls_entry-path. ls_result-bytes_b = ls_entry-size.
    CLEAR: lv_a, lv_b, lv_c, lv_aok, lv_bok, lv_cok.
    PERFORM im_get USING im_zip_b im_entries_b ls_entry-path CHANGING lv_b lv_bok.
    ls_result-b_ok = lv_bok.
* Join additions by path: a new file present in both snapshots is one row.
    READ TABLE im_current_index WITH TABLE KEY path = ls_entry-path TRANSPORTING NO FIELDS.
    IF sy-subrc = 0. CONTINUE. ENDIF.
    ls_result-zip_change = 'NEW_IN_ZIP'.
    ls_result-sap_change = 'NO_BASELINE'.
    ls_result-comparison = 'NEW_UNMAPPED'. ls_result-validation = 'MANUAL_MAPPING_REQUIRED'.
    ls_result-read_state = 'READ_NOT_RUN'.
    ls_result-read_note = '원본 목록에 없는 파일이므로 연결할 SAP 객체를 자동으로 지정하지 않았습니다.'.
    ls_result-version_state = 'VER_NOT_RUN'.
    ls_result-version_note = '연결할 SAP 객체가 확정되지 않아 활성 버전 확인을 수행하지 않았습니다.'.
    ls_result-light = '2'.
    ls_result-message = '원본 manifest에 없는 파일입니다. SAP 객체를 임의로 생성하지 않습니다.'.
    PERFORM im_document_path USING ls_entry-path CHANGING lv_doc.
    IF lv_doc = 'X'.
      ls_result-comparison = 'DOCUMENT_ONLY'.
      ls_result-validation = 'NOT_APPLICABLE'.
      ls_result-read_state = 'READ_NOT_APPLICABLE'.
      ls_result-read_note = '추출본에 추가된 업무문서이며 SAP 저장소 조회 대상이 아닙니다.'.
      ls_result-version_state = 'VER_NOT_APPLICABLE'.
      ls_result-version_note = '업무문서 파일은 SAP 활성화 대상이 아닙니다.'.
      ls_result-message = '업무 문서입니다. SAP 코드 비교·문법 검사·반영 대상에서 제외합니다.'.
    ENDIF.
    PERFORM im_pair_result USING lv_a lv_b lv_c CHANGING ls_result.
    APPEND ls_result TO im_results.
  ENDLOOP.
  LOOP AT im_current_index INTO ls_live.
    PERFORM im_progress_pulse USING ls_live-path.
    READ TABLE im_manifest_index WITH TABLE KEY path = ls_live-path
      TRANSPORTING NO FIELDS.
    IF sy-subrc = 0. CONTINUE. ENDIF.
    CLEAR ls_result. ADD 1 TO lv_id. ls_result-id = lv_id.
    ls_result-path = ls_live-path. ls_result-devclass = ls_live-devclass.
    ls_result-object = ls_live-object. ls_result-obj_name = ls_live-obj_name.
    ls_result-component = ls_live-component.
    ls_result-bytes_c = ls_live-byte_length.
    CLEAR: lv_a, lv_b, lv_c, lv_bok, lv_cok.
    READ TABLE im_current INTO ls_blob WITH TABLE KEY path = ls_live-path.
    IF sy-subrc = 0. lv_c = ls_blob-data. lv_cok = 'X'. ENDIF.
    PERFORM im_get USING im_zip_b im_entries_b ls_live-path CHANGING lv_b lv_bok.
    ls_result-b_ok = lv_bok. ls_result-c_ok = lv_cok.
    ls_result-bytes_b = xstrlen( lv_b ). ls_result-active_c = ls_live-active_state.
    ls_result-comparison = 'SAP_ONLY_NEW'. ls_result-validation = 'NOT_CHECKED'.
    ls_result-zip_change = 'NO_BASELINE'. ls_result-sap_change = 'NEW_IN_SAP'.
    PERFORM im_read_state USING ls_live
      CHANGING ls_result-read_state ls_result-read_note
          ls_result-version_state ls_result-version_note.
    ls_result-light = '2'.
    ls_result-message = '현재 SAP에 있으나 원본 manifest에 없는 파일입니다.'.
    IF lv_bok IS INITIAL.
      READ TABLE im_entries_b WITH TABLE KEY path = ls_live-path TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        ls_result-validation = 'NO_EXTRACT_TARGET'.
        ls_result-message = '현재 SAP에만 있습니다. 추출본 파일이 없어 문법·형식 검사 대상이 없습니다. 삭제 요청이 아닙니다.'.
      ELSE.
        ls_result-message = '추출본 항목은 있으나 읽지 못하여 문법·형식 검사를 수행하지 못했습니다.'.
      ENDIF.
    ENDIF.
    IF lv_bok = 'X'.
      IF lv_b = lv_c. ls_result-validation = 'IDENTICAL_NOT_TESTED'.
      ELSE. PERFORM im_validate_file USING ls_live lv_b CHANGING ls_result. ENDIF.
      PERFORM im_xml_compare USING ls_live lv_a lv_b lv_c space lv_bok lv_cok
        CHANGING ls_result.
    ENDIF.
    PERFORM im_pair_result USING lv_a lv_b lv_c CHANGING ls_result.
    APPEND ls_result TO im_results.
  ENDLOOP.
ENDFORM.


FORM im_split USING pv_text TYPE string
              CHANGING ct_lines TYPE ty_lines cv_error TYPE string.
  DATA: lv_text TYPE string, lv_at TYPE i, lv_pos TYPE i,
        lv_len TYPE i, lv_total TYPE i, lv_count TYPE i, lv_line TYPE string.
  REFRESH ct_lines. CLEAR cv_error. lv_text = pv_text.
  IF strlen( lv_text ) > 2097152.
    cv_error = 'TEXT_LIMIT: more than 2 Mi characters; use external source review'.
    RETURN.
  ENDIF.
  REPLACE ALL OCCURRENCES OF im_crlf IN lv_text WITH gv_lf.
  REPLACE ALL OCCURRENCES OF im_cr IN lv_text WITH gv_lf.
  lv_total = strlen( lv_text ).
  WHILE lv_pos < lv_total.
    FIND FIRST OCCURRENCE OF gv_lf IN SECTION OFFSET lv_pos OF lv_text
      MATCH OFFSET lv_at.
    IF sy-subrc <> 0. lv_at = lv_total. ENDIF.
    lv_len = lv_at - lv_pos.
    lv_line = lv_text+lv_pos(lv_len). APPEND lv_line TO ct_lines.
    ADD 1 TO lv_count.
    IF lv_count > 120000.
      REFRESH ct_lines.
      cv_error = 'TEXT_LIMIT: more than 120000 lines; use external source review'.
      RETURN.
    ENDIF.
    lv_pos = lv_at + 1.
  ENDWHILE.
ENDFORM.

FORM im_prepare_sources.
  DATA: ls_live TYPE ty_file, ls_file TYPE ty_file, ls_blob TYPE im_blob,
        ls_source TYPE im_source, lv_a TYPE xstring, lv_b TYPE xstring,
        lv_c TYPE xstring, lv_aok TYPE c, lv_bok TYPE c, lv_cok TYPE c,
        lv_name TYPE ty_name, ls_trdir TYPE trdir, ls_existing TYPE im_source.
  LOOP AT im_current_index INTO ls_live.
    IF ( ls_live-object <> 'PROG' AND ls_live-object <> 'FUGR' ) OR
       ls_live-path NP '*.abap' OR ls_live-active_state <> 'A'.
      CONTINUE.
    ENDIF.
    lv_name = ls_live-component.
    IF lv_name <> ls_live-component. CONTINUE. ENDIF.
    SELECT SINGLE * FROM trdir INTO ls_trdir WHERE name = lv_name.
    IF sy-subrc <> 0. CONTINUE. ENDIF.
    READ TABLE im_current INTO ls_blob WITH TABLE KEY path = ls_live-path.
    IF sy-subrc <> 0. CONTINUE. ENDIF.
    CLEAR ls_source.
    ls_source-name = lv_name. ls_source-path = ls_live-path.
    ls_source-subc = ls_trdir-subc. ls_source-data = ls_blob-data.
    READ TABLE im_manifest_index INTO ls_file
      WITH TABLE KEY path = ls_live-path.
    IF sy-subrc = 0.
      IF ls_live-component <> ls_file-component OR
         ls_live-obj_name <> ls_file-obj_name OR
         ls_live-object <> ls_file-object OR
         ls_live-devclass <> ls_file-devclass.
        ls_source-error = 'Source mapping differs from live identity'.
      ELSE.
        PERFORM im_triplet USING ls_file CHANGING lv_a lv_b lv_c
          lv_aok lv_bok lv_cok.
        IF lv_bok IS INITIAL OR lv_cok IS INITIAL.
          ls_source-error = 'ZIP or current SAP source is unavailable'.
        ELSE.
* Build a read-only virtual ZIP target over CURRENT SAP dependencies.
* The baseline is for history columns, not the syntax-selection gate.
          IF lv_b <> lv_c.
            ls_source-data = lv_b.
            ls_source-changed = 'X'. ls_source-edited = 'X'.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    INSERT ls_source INTO TABLE im_sources.
    IF sy-subrc <> 0.
      READ TABLE im_sources INTO ls_existing
        WITH TABLE KEY name = ls_source-name.
      ls_existing-error = 'Same program has multiple source paths; ambiguous context'.
      MODIFY TABLE im_sources FROM ls_existing.
    ENDIF.
  ENDLOOP.
  PERFORM im_function_overrides.
ENDFORM.

FORM im_function_head USING pv_data TYPE xstring
                      CHANGING cv_function TYPE rs38l-name.
  DATA: lv_text TYPE string, lv_error TYPE string, lt_lines TYPE ty_lines,
        lv_line TYPE string, lv_name TYPE string.
  CLEAR cv_function.
  PERFORM im_decode USING pv_data CHANGING lv_text lv_error.
  IF lv_error IS NOT INITIAL. RETURN. ENDIF.
  PERFORM im_split USING lv_text CHANGING lt_lines lv_error.
  IF lv_error IS NOT INITIAL. RETURN. ENDIF.
  LOOP AT lt_lines INTO lv_line.
    IF lv_line IS INITIAL OR lv_line(1) = '*'. CONTINUE. ENDIF.
    SHIFT lv_line LEFT DELETING LEADING space.
    IF lv_line IS INITIAL OR lv_line(1) = '"'. CONTINUE. ENDIF.
    TRANSLATE lv_line TO UPPER CASE.
    FIND REGEX '^FUNCTION[ ]+([A-Z0-9_/]+)[ ]*\.' IN lv_line
      SUBMATCHES lv_name.
    IF sy-subrc = 0 AND strlen( lv_name ) <= 30.
      cv_function = lv_name.
    ENDIF.
    EXIT.
  ENDLOOP.
ENDFORM.

FORM im_function_overrides.
* Only substitute a full, uniquely identified active function include.
* Current function interfaces remain in SAP; edited interface XML is NOT applied.
  DATA: ls_src TYPE im_source, ls_live TYPE ty_file, ls_file TYPE ty_file,
        ls_blob TYPE im_blob, ls_tfdir TYPE tfdir, lv_area TYPE rs38l-area,
        lv_func TYPE rs38l-name, lv_bfunc TYPE rs38l-name,
        lv_pkg TYPE string, lv_group TYPE string, lv_leaf TYPE string,
        lv_path TYPE string, lv_a TYPE xstring, lv_b TYPE xstring,
        lv_c TYPE xstring, lv_aok TYPE c, lv_bok TYPE c, lv_cok TYPE c.
  LOOP AT im_sources INTO ls_src WHERE subc = 'I'.
    READ TABLE im_current_index INTO ls_live WITH TABLE KEY path = ls_src-path.
    IF sy-subrc <> 0 OR ls_live-object <> 'FUGR'. CONTINUE. ENDIF.
    READ TABLE im_current INTO ls_blob WITH TABLE KEY path = ls_src-path.
    IF sy-subrc <> 0. CONTINUE. ENDIF.
    PERFORM im_function_head USING ls_blob-data CHANGING lv_func.
    IF lv_func IS INITIAL. CONTINUE. ENDIF.
    CLEAR lv_area.
    SELECT SINGLE area FROM enlfdir INTO lv_area WHERE funcname = lv_func.
    IF sy-subrc <> 0 OR lv_area <> ls_live-obj_name. CONTINUE. ENDIF.
    SELECT SINGLE * FROM tfdir INTO ls_tfdir WHERE funcname = lv_func.
    IF sy-subrc <> 0. CONTINUE. ENDIF.
    READ TABLE im_sources WITH TABLE KEY name = ls_tfdir-pname
      TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0. CONTINUE. ENDIF.
    PERFORM segment USING ls_live-devclass CHANGING lv_pkg.
    PERFORM segment USING ls_live-obj_name CHANGING lv_group.
    PERFORM segment USING lv_func CHANGING lv_leaf.
    CONCATENATE 'packages/' lv_pkg '/function-groups/FUGR/' lv_group
      '/Function Module/' lv_leaf '/Source code/' lv_leaf '.abap'
      INTO lv_path.
    READ TABLE im_manifest_index INTO ls_file WITH TABLE KEY path = lv_path.
    IF sy-subrc <> 0 OR ls_file-component <> 'FUNCTION_API_SOURCE' OR
       ls_file-object <> 'FUGR' OR ls_file-obj_name <> ls_live-obj_name OR
       ls_file-devclass <> ls_live-devclass. CONTINUE. ENDIF.
    PERFORM im_triplet USING ls_file CHANGING lv_a lv_b lv_c
      lv_aok lv_bok lv_cok.
    IF lv_cok IS INITIAL OR lv_bok IS INITIAL.
      ls_src-error = 'Function ZIP or SAP representation unavailable'.
    ELSEIF lv_c <> lv_b.
      ls_src-alias = lv_path.
      PERFORM im_function_head USING lv_b CHANGING lv_bfunc.
      IF lv_bfunc <> lv_func.
        ls_src-error = 'FUNCTION identity changed; manual mapping required'.
      ELSEIF ls_src-edited = 'X' AND ls_src-data <> lv_b.
        ls_src-error = 'Function Source code and Include edits disagree; choose one representation'.
      ELSE.
        ls_src-data = lv_b. ls_src-changed = 'X'.
      ENDIF.
    ENDIF.
    MODIFY TABLE im_sources FROM ls_src.
  ENDLOOP.
ENDFORM.

FORM im_expand USING pv_name TYPE ty_name pv_depth TYPE i
               CHANGING ct_program TYPE ty_lines ct_map TYPE im_maps
                        ct_members TYPE im_paths cv_changed TYPE c
                        cv_error TYPE string.
  DATA: ls_src TYPE im_source, lt_lines TYPE ty_lines,
        lt_inc TYPE ty_includes, ls_inc TYPE ty_include,
        lt_gaps TYPE ty_scan_gaps, lv_ok TYPE c, lv_text TYPE string,
        lv_line TYPE string, lv_check TYPE string, lv_error TYPE string,
        lv_line_no TYPE i, lv_n TYPE i, lv_at TYPE i,
        lv_depth TYPE i, ls_map TYPE im_map.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  IF pv_depth > 32.
    cv_error = 'INCLUDE expansion exceeds 32 levels'. RETURN.
  ENDIF.
  READ TABLE im_sources INTO ls_src WITH TABLE KEY name = pv_name.
  IF sy-subrc <> 0.
    cv_error = 'Source context missing'. RETURN.
  ENDIF.
  INSERT ls_src-path INTO TABLE ct_members.
  IF ls_src-alias IS NOT INITIAL. INSERT ls_src-alias INTO TABLE ct_members. ENDIF.
  IF ls_src-changed = 'X'. cv_changed = 'X'. ENDIF.
  IF ls_src-error IS NOT INITIAL. cv_error = ls_src-error. RETURN. ENDIF.
  INSERT pv_name INTO TABLE im_stack.
  IF sy-subrc <> 0.
    cv_error = 'Cyclic INCLUDE context'. RETURN.
  ENDIF.
  PERFORM im_decode USING ls_src-data CHANGING lv_text lv_error.
  IF lv_error IS NOT INITIAL.
    cv_error = lv_error. DELETE TABLE im_stack FROM pv_name. RETURN.
  ENDIF.
  PERFORM im_split USING lv_text CHANGING lt_lines lv_error.
  IF lv_error IS NOT INITIAL.
    cv_error = lv_error. DELETE TABLE im_stack FROM pv_name. RETURN.
  ENDIF.
  PERFORM read_direct_includes USING lt_lines
    CHANGING lt_inc lt_gaps lv_ok.
  IF lv_ok IS INITIAL OR lt_gaps IS NOT INITIAL.
    cv_error = 'INCLUDE scan incomplete (macro/dynamic/unsupported statement)'.
    DELETE TABLE im_stack FROM pv_name. RETURN.
  ENDIF.
  LOOP AT lt_lines INTO lv_line.
    lv_line_no = sy-tabix.
    READ TABLE lt_inc INTO ls_inc WITH KEY source_line = lv_line_no.
    IF sy-subrc = 0.
      READ TABLE im_sources WITH TABLE KEY name = ls_inc-name
        TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
* Replace only a complete single-line INCLUDE; never remove adjacent code.
        lv_check = lv_line. TRANSLATE lv_check TO UPPER CASE.
        REPLACE ALL OCCURRENCES OF gv_tab IN lv_check WITH space.
        FIND REGEX '^[ ]*INCLUDE[ ]+[A-Z0-9_/]+[ ]*(IF[ ]+FOUND)?[ ]*\.[ ]*(".*)?$'
          IN lv_check.
        IF sy-subrc <> 0.
          cv_error = 'Multiline/chained/combined INCLUDE needs manual context review'.
          EXIT.
        ENDIF.
        lv_depth = pv_depth + 1.
        PERFORM im_expand USING ls_inc-name lv_depth
          CHANGING ct_program ct_map ct_members cv_changed cv_error.
        IF cv_error IS NOT INITIAL. EXIT. ENDIF.
        CONTINUE.
      ENDIF.
* An unexported dependency remains a SAP INCLUDE. The compiler resolves it
* using its CURRENT repository version. It is not exported or overwritten.
    ENDIF.
    IF strlen( lv_line ) > 255.
      cv_error = 'ABAP source line exceeds 255 characters; not truncated'. EXIT.
    ENDIF.
    APPEND lv_line TO ct_program.
    ls_map-program = pv_name. ls_map-path = ls_src-path.
    IF ls_src-alias IS NOT INITIAL. ls_map-path = ls_src-alias. ENDIF.
    ls_map-line = lv_line_no. APPEND ls_map TO ct_map.
    DESCRIBE TABLE ct_program LINES lv_n.
    IF lv_n > 120000.
      cv_error = 'Virtual main program exceeds 120000 lines'. EXIT.
    ENDIF.
  ENDLOOP.
  DELETE TABLE im_stack FROM pv_name.
ENDFORM.

FORM im_store_check USING ps_check TYPE im_check.
  DATA ls_old TYPE im_check.
  READ TABLE im_checks INTO ls_old WITH TABLE KEY path = ps_check-path.
  IF sy-subrc <> 0. INSERT ps_check INTO TABLE im_checks. RETURN. ENDIF.
* Shared includes may be used by several mains. Preserve the worst result.
  IF ls_old-status = 'SYNTAX_PRECHECK_ERROR'. RETURN. ENDIF.
  IF ls_old-status = 'CONTEXT_REQUIRED' AND
     ps_check-status = 'SYNTAX_PRECHECK_OK'. RETURN. ENDIF.
  MODIFY TABLE im_checks FROM ps_check.
ENDFORM.

FORM im_syntax_units.
  DATA: ls_main TYPE im_source, lt_program TYPE ty_lines,
        lt_map TYPE im_maps, ls_map TYPE im_map,
        lt_members TYPE im_paths, lv_member TYPE string,
        lv_changed TYPE c, lv_error TYPE string,
        lv_message TYPE c LENGTH 255, lv_line TYPE i,
        lv_word TYPE c LENGTH 255, lv_include TYPE ty_name,
        lv_rc TYPE sy-subrc, ls_check TYPE im_check,
        lt_fixed TYPE STANDARD TABLE OF im_char255,
        lv_fixed TYPE im_char255, lv_source_line TYPE string,
        lv_total TYPE i, lv_done TYPE i, lo_err TYPE REF TO cx_root.
  gv_stage = 'SYNTAX_PRECHECK'.
  LOOP AT im_sources INTO ls_main WHERE subc <> 'I'.
    ADD 1 TO lv_total.
  ENDLOOP.
  PERFORM im_progress USING 'ABAP 문법 사전검사' 0 lv_total space.
  LOOP AT im_sources INTO ls_main WHERE subc <> 'I'.
    ADD 1 TO lv_done.
    PERFORM im_progress_item USING 'ABAP 문법 사전검사' lv_done lv_total ls_main-name.
    REFRESH: lt_program, lt_map, lt_members, im_stack, lt_fixed.
    CLEAR: lv_changed, lv_error, ls_check, lv_include,
           lv_message, lv_line, lv_word.
    PERFORM im_expand USING ls_main-name 0
      CHANGING lt_program lt_map lt_members lv_changed lv_error.
    IF lv_changed IS INITIAL AND lv_error IS INITIAL. CONTINUE. ENDIF.
    IF lv_error IS INITIAL.
      ADD 1 TO im_units.
      LOOP AT lt_program INTO lv_source_line.
        lv_fixed = lv_source_line. APPEND lv_fixed TO lt_fixed.
      ENDLOOP.
      TRY.
          SYNTAX-CHECK FOR lt_fixed MESSAGE lv_message LINE lv_line
            WORD lv_word PROGRAM ls_main-name INCLUDE lv_include.
          lv_rc = sy-subrc.
        CATCH cx_root INTO lo_err.
          lv_error = lo_err->get_text( ).
      ENDTRY.
    ENDIF.
    IF lv_error IS NOT INITIAL.
      ls_check-status = 'CONTEXT_REQUIRED'. ls_check-message = lv_error.
    ELSEIF lv_rc = 0.
      ls_check-status = 'SYNTAX_PRECHECK_OK'.
      CONCATENATE 'Main=' ls_main-name
        '; current SAP DDIC/interfaces/dependencies'
        INTO ls_check-message.
    ELSE.
      ls_check-status = 'SYNTAX_PRECHECK_ERROR'.
      ls_check-program = lv_include. ls_check-line = lv_line.
      IF lv_include IS INITIAL OR lv_include = ls_main-name.
        READ TABLE lt_map INTO ls_map INDEX lv_line.
        IF sy-subrc = 0.
          ls_check-program = ls_map-program. ls_check-line = ls_map-line.
        ENDIF.
      ENDIF.
      CONCATENATE 'Main=' ls_main-name '; ' lv_message
        INTO ls_check-message RESPECTING BLANKS.
    ENDIF.
    LOOP AT lt_members INTO lv_member.
      ls_check-path = lv_member. PERFORM im_store_check USING ls_check.
    ENDLOOP.
  ENDLOOP.
ENDFORM.

FORM im_apply_checks.
  DATA: ls_result TYPE im_result, ls_check TYPE im_check, lv_i TYPE i,
        lv_path TYPE string.
  LOOP AT im_results INTO ls_result.
    lv_i = sy-tabix.
    IF ls_result-validation <> 'CONTEXT_REQUIRED'. CONTINUE. ENDIF.
    lv_path = ls_result-path.
    READ TABLE im_checks INTO ls_check WITH TABLE KEY path = lv_path.
    IF sy-subrc <> 0. CONTINUE. ENDIF.
    ls_result-validation = ls_check-status.
    ls_result-error_program = ls_check-program.
    ls_result-error_line = ls_check-line. ls_result-message = ls_check-message.
    IF ls_check-status = 'SYNTAX_PRECHECK_ERROR'. ls_result-light = '1'. ENDIF.
    MODIFY im_results FROM ls_result INDEX lv_i.
  ENDLOOP.
ENDFORM.


FORM im_diff_lines USING pt_old TYPE ty_lines pt_new TYPE ty_lines
                   CHANGING ct_diff TYPE im_diffs cv_note TYPE string.
* Bounded LCS on the changed middle; equal prefix/suffix cost O(n).
* Beyond the cell budget: exact whole-middle delete/add, not a minimal diff.
  DATA: lv_n TYPE i, lv_m TYPE i, lv_prefix TYPE i, lv_suffix TYPE i,
        lv_i TYPE i, lv_j TYPE i, lv_oi TYPE i, lv_nj TYPE i,
        lv_nr TYPE i, lv_mr TYPE i, lv_width TYPE i, lv_cells TYPE i,
        lv_rows TYPE i,
        lv_idx TYPE i, lv_ix TYPE i, lv_a TYPE i, lv_b TYPE i,
        lv_value TYPE i, lt_dp TYPE STANDARD TABLE OF i,
        lv_old TYPE string, lv_new TYPE string, ls_diff TYPE im_diff,
        lv_start TYPE i, lv_end TYPE i.
  REFRESH ct_diff. CLEAR cv_note.
  DESCRIBE TABLE pt_old LINES lv_n. DESCRIBE TABLE pt_new LINES lv_m.
  WHILE lv_prefix < lv_n AND lv_prefix < lv_m.
    lv_i = lv_prefix + 1.
    READ TABLE pt_old INTO lv_old INDEX lv_i.
    READ TABLE pt_new INTO lv_new INDEX lv_i.
    IF lv_old <> lv_new. EXIT. ENDIF.
    ADD 1 TO lv_prefix.
  ENDWHILE.
  IF lv_prefix = lv_n AND lv_prefix = lv_m. RETURN. ENDIF.
  lv_nr = lv_n - lv_prefix.
  lv_mr = lv_m - lv_prefix.
  WHILE lv_suffix < lv_nr AND lv_suffix < lv_mr.
    lv_i = lv_n - lv_suffix. lv_j = lv_m - lv_suffix.
    READ TABLE pt_old INTO lv_old INDEX lv_i.
    READ TABLE pt_new INTO lv_new INDEX lv_j.
    IF lv_old <> lv_new. EXIT. ENDIF.
    ADD 1 TO lv_suffix.
  ENDWHILE.
  lv_start = lv_prefix - 2. IF lv_start < 1. lv_start = 1. ENDIF.
  lv_i = lv_start.
  WHILE lv_i <= lv_prefix.
    READ TABLE pt_old INTO lv_old INDEX lv_i.
    CLEAR ls_diff. ls_diff-old_line = lv_i. ls_diff-new_line = lv_i.
    ls_diff-text = lv_old. APPEND ls_diff TO ct_diff. ADD 1 TO lv_i.
  ENDWHILE.
  lv_nr = lv_n - lv_prefix - lv_suffix.
  lv_mr = lv_m - lv_prefix - lv_suffix. lv_width = lv_mr + 1.
* Divide before multiplying to prevent INT4 overflow for large sources.
  lv_cells = 250000 DIV lv_width.
  lv_rows = lv_nr + 1.
  IF lv_rows > lv_cells.
    cv_note = 'Whole changed block shown (LCS budget exceeded); alignment is not minimal'.
    lv_i = lv_prefix + 1. lv_end = lv_n - lv_suffix.
    WHILE lv_i <= lv_end.
      READ TABLE pt_old INTO lv_old INDEX lv_i.
      CLEAR ls_diff. ls_diff-kind = '-'. ls_diff-old_line = lv_i.
      ls_diff-text = lv_old. APPEND ls_diff TO ct_diff. ADD 1 TO lv_i.
    ENDWHILE.
    lv_j = lv_prefix + 1. lv_end = lv_m - lv_suffix.
    WHILE lv_j <= lv_end.
      READ TABLE pt_new INTO lv_new INDEX lv_j.
      CLEAR ls_diff. ls_diff-kind = '+'. ls_diff-new_line = lv_j.
      ls_diff-text = lv_new. APPEND ls_diff TO ct_diff. ADD 1 TO lv_j.
    ENDWHILE.
  ELSE.
    lv_cells = ( lv_nr + 1 ) * lv_width. CLEAR lv_value.
    DO lv_cells TIMES. APPEND lv_value TO lt_dp. ENDDO.
    lv_i = lv_nr - 1.
    WHILE lv_i >= 0.
      lv_j = lv_mr - 1.
      lv_oi = lv_prefix + lv_i + 1.
      READ TABLE pt_old INTO lv_old INDEX lv_oi.
      WHILE lv_j >= 0.
        lv_nj = lv_prefix + lv_j + 1.
        READ TABLE pt_new INTO lv_new INDEX lv_nj.
        IF lv_old = lv_new.
          lv_ix = ( lv_i + 1 ) * lv_width + lv_j + 2.
          READ TABLE lt_dp INTO lv_value INDEX lv_ix. ADD 1 TO lv_value.
        ELSE.
          lv_ix = ( lv_i + 1 ) * lv_width + lv_j + 1.
          READ TABLE lt_dp INTO lv_a INDEX lv_ix.
          lv_ix = lv_i * lv_width + lv_j + 2.
          READ TABLE lt_dp INTO lv_b INDEX lv_ix.
          lv_value = lv_a. IF lv_b > lv_a. lv_value = lv_b. ENDIF.
        ENDIF.
        lv_idx = lv_i * lv_width + lv_j + 1.
        MODIFY lt_dp FROM lv_value INDEX lv_idx. SUBTRACT 1 FROM lv_j.
      ENDWHILE.
      SUBTRACT 1 FROM lv_i.
    ENDWHILE.
    CLEAR: lv_i, lv_j.
    WHILE lv_i < lv_nr OR lv_j < lv_mr.
      lv_oi = lv_prefix + lv_i + 1. lv_nj = lv_prefix + lv_j + 1.
      CLEAR: lv_old, lv_new, ls_diff.
      IF lv_i < lv_nr. READ TABLE pt_old INTO lv_old INDEX lv_oi. ENDIF.
      IF lv_j < lv_mr. READ TABLE pt_new INTO lv_new INDEX lv_nj. ENDIF.
      IF lv_i < lv_nr AND lv_j < lv_mr AND lv_old = lv_new.
        ls_diff-old_line = lv_oi. ls_diff-new_line = lv_nj. ls_diff-text = lv_old.
        ADD 1 TO lv_i. ADD 1 TO lv_j.
      ELSE.
        CLEAR: lv_a, lv_b.
        IF lv_i < lv_nr AND lv_j < lv_mr.
          lv_ix = ( lv_i + 1 ) * lv_width + lv_j + 1.
          READ TABLE lt_dp INTO lv_a INDEX lv_ix.
          lv_ix = lv_i * lv_width + lv_j + 2.
          READ TABLE lt_dp INTO lv_b INDEX lv_ix.
        ENDIF.
        IF lv_i < lv_nr AND ( lv_j = lv_mr OR lv_a >= lv_b ).
          ls_diff-kind = '-'. ls_diff-old_line = lv_oi. ls_diff-text = lv_old.
          ADD 1 TO lv_i.
        ELSE.
          ls_diff-kind = '+'. ls_diff-new_line = lv_nj. ls_diff-text = lv_new.
          ADD 1 TO lv_j.
        ENDIF.
      ENDIF.
      APPEND ls_diff TO ct_diff.
    ENDWHILE.
  ENDIF.
  lv_end = lv_suffix. IF lv_end > 3. lv_end = 3. ENDIF.
  DO lv_end TIMES.
    lv_i = lv_n - lv_suffix + sy-index.
    lv_j = lv_m - lv_suffix + sy-index.
    READ TABLE pt_old INTO lv_old INDEX lv_i.
    CLEAR ls_diff. ls_diff-old_line = lv_i. ls_diff-new_line = lv_j.
    ls_diff-text = lv_old. APPEND ls_diff TO ct_diff.
  ENDDO.
ENDFORM.

FORM im_selftest.
  DATA: lv_a TYPE xstring, lv_b TYPE xstring, lv_c TYPE xstring,
        lv_status TYPE c LENGTH 24, lv_error TYPE string, lv_path TYPE string,
        lv_zip_change TYPE c LENGTH 24, lv_sap_change TYPE c LENGTH 24,
        lt_old TYPE ty_lines, lt_new TYPE ty_lines, lt_diff TYPE im_diffs,
        ls_diff TYPE im_diff, lv_count TYPE i.
  lv_a = '00'. lv_b = '00'. lv_c = '00'.
  PERFORM im_compare_values USING lv_a lv_b lv_c 'X' 'X' 'X'
    CHANGING lv_zip_change lv_sap_change lv_status.
  IF lv_zip_change <> 'UNCHANGED' OR lv_sap_change <> 'UNCHANGED' OR
     lv_status <> 'IDENTICAL'.
    gv_fatal = 'Byte comparison self-test 1 failed'. RETURN.
  ENDIF.
* All three buffers have the same byte LENGTH but different CONTENT.
  lv_b = '01'.
  PERFORM im_compare_values USING lv_a lv_b lv_c 'X' 'X' 'X'
    CHANGING lv_zip_change lv_sap_change lv_status.
  IF lv_zip_change <> 'CHANGED' OR lv_sap_change <> 'UNCHANGED' OR
     lv_status <> 'DIFFERENT'.
    gv_fatal = 'Byte comparison self-test 2 failed'. RETURN.
  ENDIF.
  lv_c = '01'.
  PERFORM im_compare_values USING lv_a lv_b lv_c 'X' 'X' 'X'
    CHANGING lv_zip_change lv_sap_change lv_status.
  IF lv_zip_change <> 'CHANGED' OR lv_sap_change <> 'CHANGED' OR
     lv_status <> 'IDENTICAL'.
    gv_fatal = 'Byte comparison self-test 3 failed'. RETURN.
  ENDIF.
  lv_b = '00'.
  PERFORM im_compare_values USING lv_a lv_b lv_c 'X' 'X' 'X'
    CHANGING lv_zip_change lv_sap_change lv_status.
  IF lv_zip_change <> 'UNCHANGED' OR lv_sap_change <> 'CHANGED' OR
     lv_status <> 'DIFFERENT'.
    gv_fatal = 'Byte comparison self-test 4 failed'. RETURN.
  ENDIF.
  lv_b = '02'.
  PERFORM im_compare_values USING lv_a lv_b lv_c 'X' 'X' 'X'
    CHANGING lv_zip_change lv_sap_change lv_status.
  IF lv_zip_change <> 'CHANGED' OR lv_sap_change <> 'CHANGED' OR
     lv_status <> 'DIFFERENT'.
    gv_fatal = 'Byte comparison self-test 5 failed'. RETURN.
  ENDIF.
  lv_path = 'packages/ZHR5/../bad'.
  PERFORM im_safe_path USING lv_path CHANGING lv_error.
  IF lv_error IS INITIAL. gv_fatal = 'ZIP path self-test failed'. RETURN. ENDIF.
  APPEND 'first' TO lt_old. APPEND 'last' TO lt_old.
  APPEND 'first' TO lt_new. APPEND 'inserted' TO lt_new. APPEND 'last' TO lt_new.
  PERFORM im_diff_lines USING lt_old lt_new CHANGING lt_diff lv_error.
  LOOP AT lt_diff INTO ls_diff WHERE kind = '+'.
    ADD 1 TO lv_count.
    IF ls_diff-new_line <> 2 OR ls_diff-text <> 'inserted'.
      gv_fatal = 'Diff insertion line mapping self-test failed'. RETURN.
    ENDIF.
  ENDLOOP.
  IF lv_count <> 1. gv_fatal = 'Diff insertion self-test failed'. RETURN. ENDIF.
  WRITE / 'PASS: exact bytes, independent baseline changes, path guard, line diff.'.
ENDFORM.


FORM im_file_name USING pv_path TYPE csequence
                  CHANGING cv_name TYPE csequence.
* Show the immediate parent and file, preserving case and extension.
  DATA: lv_path TYPE string, lt_parts TYPE ty_lines, lv_part TYPE string,
        lv_parent TYPE string, lv_file TYPE string.
  CLEAR cv_name.
  lv_path = pv_path.
  REPLACE ALL OCCURRENCES OF '\' IN lv_path WITH '/'.
  SPLIT lv_path AT '/' INTO TABLE lt_parts.
  LOOP AT lt_parts INTO lv_part.
    IF lv_part IS INITIAL. CONTINUE. ENDIF.
    lv_parent = lv_file. lv_file = lv_part.
  ENDLOOP.
  IF lv_parent IS INITIAL.
    cv_name = lv_file.
  ELSE.
    CONCATENATE lv_parent lv_file INTO cv_name SEPARATED BY '/'.
  ENDIF.
ENDFORM.

FORM im_column USING pv_field TYPE c pv_text TYPE c pv_len TYPE i.
  DATA: ls_field TYPE slis_fieldcat_alv, lv_position TYPE i.
  ls_field-fieldname = pv_field. ls_field-seltext_l = pv_text.
  ls_field-seltext_m = pv_text. ls_field-seltext_s = pv_text.
  ls_field-outputlen = pv_len.
  DESCRIBE TABLE im_fcat LINES lv_position.
  ls_field-col_pos = lv_position + 1.
* The exception light is ALV's native leftmost column. The next three
* visible columns form one fixed key block during horizontal scrolling.
  IF pv_field = 'OBJECT' OR pv_field = 'COMPONENT' OR pv_field = 'FILENAME'.
    ls_field-key = 'X'. ls_field-fix_column = 'X'.
  ENDIF.
  IF pv_field = 'PATH' OR pv_field = 'FILENAME' OR pv_field = 'ZIP_CHANGE_TEXT' OR
     pv_field = 'SAP_CHANGE_TEXT' OR pv_field = 'COMPARISON_TEXT'.
    ls_field-hotspot = 'X'.
  ENDIF.
  APPEND ls_field TO im_fcat.
ENDFORM.

FORM im_show.
  REFRESH im_fcat.
  CLEAR im_layout.

  DESCRIBE TABLE im_results LINES im_count.
  CONCATENATE 'DEVHUB DIAG 0.7.1 /' im_filter_label '/ 진단 시점 A·B·C 비교' INTO im_title SEPARATED BY space.
  im_layout-zebra = 'X'. im_layout-lights_fieldname = 'LIGHT'.
  PERFORM wa_columns.
  PERFORM im_column USING 'OBJECT' '유형' 4.
  PERFORM im_column USING 'COMPONENT' '구성요소' 20.
  PERFORM im_column USING 'FILENAME' '파일명' 48.
  PERFORM im_column USING 'ZIP_CHANGE_TEXT' '추출본/원본 대비' 16.
  PERFORM im_column USING 'SAP_CHANGE_TEXT' 'SAP/원본 대비' 16.
  PERFORM im_column USING 'COMPARISON_TEXT' '추출본/SAP 대비' 16.
  PERFORM im_column USING 'READ_TEXT' 'SAP 검증 결과' 18.
  PERFORM im_column USING 'READ_NOTE' 'SAP 검증 결과 설명' 36.
  PERFORM im_column USING 'VERSION_TEXT' '활성 버전 확인 결과' 22.
  PERFORM im_column USING 'VERSION_NOTE' '활성 버전 확인 설명' 40.
  PERFORM im_column USING 'VALIDATION_TEXT' '문법형식 검증' 22.
  PERFORM im_column USING 'DEVCLASS' '개발클래스' 12.
  PERFORM im_column USING 'OBJ_NAME' '객체명' 28.
  PERFORM im_column USING 'PATH' '파일경로' 44.
  PERFORM im_column USING 'BYTES_A' '원본 bytes' 12.
  PERFORM im_column USING 'BYTES_B' '추출본 bytes' 12.
  PERFORM im_column USING 'BYTES_C' 'SAP bytes' 12.
  PERFORM im_column USING 'ERROR_PROGRAM' '오류 프로그램' 24.
  PERFORM im_column USING 'ERROR_LINE' '오류 행' 8.
  PERFORM im_column USING 'MESSAGE' '검증 설명' 40.
  PERFORM im_header_free.
  PERFORM im_header_main_data.
  im_body_fit_active = 'X'. im_screen_mode = 'M'. CLEAR im_toolbar_grid.
  SET HANDLER lcl_im_alv_fit=>after_refresh lcl_im_alv_fit=>toolbar
    lcl_im_alv_fit=>command FOR ALL INSTANCES.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING i_callback_program = im_program
      i_callback_user_command = 'IM_USER_COMMAND'
      i_callback_pf_status_set = 'IM_MAIN_STATUS'
      i_grid_title = im_title is_layout = im_layout
      it_fieldcat = im_fcat
    TABLES t_outtab = im_results
    EXCEPTIONS program_error = 1 OTHERS = 2.
  IF sy-subrc <> 0. WRITE / 'ALV 결과 화면 표시 실패'. ENDIF.
  CLEAR: im_body_fit_active, im_screen_mode, im_toolbar_grid.
  SET HANDLER lcl_im_alv_fit=>after_refresh lcl_im_alv_fit=>toolbar
    lcl_im_alv_fit=>command FOR ALL INSTANCES ACTIVATION space.
  PERFORM im_header_free.
ENDFORM.

FORM im_top.
  DATA: lt_header TYPE slis_t_listheader, ls_header TYPE slis_listheader,
        lt_lines TYPE ty_lines, lv_line TYPE string,
        lv_take TYPE i, lv_len TYPE i, lv_width TYPE i.
  PERFORM im_summary CHANGING lt_lines.
  lv_line = '원본 / 추출본 / 현재 SAP 비교 검증 리포트'.
  INSERT lv_line INTO lt_lines INDEX 1.
  DESCRIBE FIELD ls_header-info LENGTH lv_width IN CHARACTER MODE.
  LOOP AT lt_lines INTO lv_line.
    lv_len = strlen( lv_line ).
    WHILE lv_len > 0.
      lv_take = lv_len. IF lv_take > lv_width. lv_take = lv_width. ENDIF.
      CLEAR ls_header. ls_header-typ = 'S'. ls_header-info = lv_line(lv_take).
      APPEND ls_header TO lt_header.
      lv_line = lv_line+lv_take. lv_len = strlen( lv_line ).
    ENDWHILE.
  ENDLOOP.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE' EXPORTING it_list_commentary = lt_header.
ENDFORM.

FORM im_user_command USING pv_ucomm LIKE sy-ucomm
                           ps_selfield TYPE slis_selfield.
  DATA ls_result TYPE im_result.
  IF pv_ucomm <> '&IC1'. RETURN. ENDIF.
  READ TABLE im_results INTO ls_result INDEX ps_selfield-tabindex.
  IF sy-subrc <> 0. RETURN. ENDIF.
  PERFORM im_detail_grid USING ls_result.
ENDFORM.

FORM im_view_value USING pv_value TYPE string CHANGING cv_text TYPE string.
* Render controls and trailing spaces explicitly without changing source.
  DATA: lv_len TYPE i, lv_at TYPE i, lv_spaces TYPE i,
        lv_num TYPE c LENGTH 12, lv_tail TYPE string, lv_char TYPE c.
  cv_text = pv_value. lv_len = strlen( cv_text ).
  WHILE lv_len > 0.
    lv_at = lv_len - 1.
    lv_char = cv_text+lv_at(1).
    IF lv_char <> space. EXIT. ENDIF.
    ADD 1 TO lv_spaces. lv_len = lv_at.
  ENDWHILE.
  IF lv_spaces > 0.
    cv_text = cv_text(lv_len).
    WRITE lv_spaces TO lv_num NO-GROUPING. CONDENSE lv_num.
    CONCATENATE '[끝 공백:' lv_num ']' INTO lv_tail.
    CONCATENATE cv_text lv_tail INTO cv_text RESPECTING BLANKS.
  ENDIF.
  REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>horizontal_tab IN cv_text WITH '[TAB]'.
  REPLACE ALL OCCURRENCES OF im_cr IN cv_text WITH '[CR]'.
  REPLACE ALL OCCURRENCES OF gv_lf IN cv_text WITH '[LF]'.
  IF cv_text IS INITIAL. cv_text = '(빈 값/빈 줄)'. ENDIF.
ENDFORM.


FORM im_status_text USING pv_code TYPE csequence CHANGING cv_text TYPE csequence.
* Presentation only. Machine codes, API names and source bytes are kept.
  cv_text = pv_code.
  CASE pv_code.
    WHEN 'DIFFERENT'. cv_text = '불일치'.
    WHEN 'DOCUMENT_ONLY'. cv_text = '업무문서'.
    WHEN 'IDENTICAL'. cv_text = '일치'.
    WHEN 'SAP_ONLY_NEW' OR 'NEW_IN_SAP'. cv_text = 'SAP 신규'.
    WHEN 'CHANGED'. cv_text = '변경'.
    WHEN 'NO_BASELINE'. cv_text = '원본 없음'.
    WHEN 'UNCHANGED'. cv_text = '변경 없음'.
    WHEN 'NEW_IN_ZIP'. cv_text = '추출본 신규'.
    WHEN 'ZIP_UNREADABLE'. cv_text = '추출본 읽기 불가'.
    WHEN 'SAP_UNREADABLE'. cv_text = 'SAP 읽기 불가'.
    WHEN 'CANNOT_COMPARE'. cv_text = '비교 불가'.
    WHEN 'OUT_OF_SCOPE'. cv_text = '범위 제외'.
    WHEN 'MAPPING_REJECTED'. cv_text = '객체 연결 거부'.
    WHEN 'NEW_UNMAPPED'. cv_text = '신규·객체 미연결'.
    WHEN 'READ_MISSING'. cv_text = '객체 없음 확인'.
    WHEN 'READ_OK'. cv_text = '조회 성공'.
    WHEN 'READ_FAILED'. cv_text = '조회 실패'.
    WHEN 'READ_DIAGNOSTIC'. cv_text = '진단 정보 생성'.
    WHEN 'READ_NOT_RUN'. cv_text = '조회 미수행'.
    WHEN 'READ_EXCLUDED'. cv_text = '조회 결과 사용 제외'.
    WHEN 'READ_NOT_SUPPORTED'. cv_text = '조회 기능 미구현'.
    WHEN 'READ_NOT_APPLICABLE'. cv_text = '조회 대상 아님'.
    WHEN 'VER_ACTIVE'. cv_text = '활성 버전 확인'.
    WHEN 'VER_ATTEMPT_FAILED'. cv_text = '확인 시도 실패'.
    WHEN 'VER_SOURCE_DIFFERENT'. cv_text = '활성 소스와 바이트 불일치'.
    WHEN 'VER_NOT_IMPLEMENTED'. cv_text = '확인 기능 미구현'.
    WHEN 'VER_NOT_RUN'. cv_text = '확인 미수행'.
    WHEN 'VER_READ_FAILED'. cv_text = '조회 실패로 미확인'.
    WHEN 'VER_NOT_APPLICABLE'. cv_text = '해당 없음'.
    WHEN 'XML_ERROR'. cv_text = 'XML 문법 오류'.
    WHEN 'XML_WELL_FORMED_ONLY'. cv_text = 'XML 기본 문법 확인'.
    WHEN 'BINARY_REVIEW'. cv_text = '바이너리 내용 비교'.
    WHEN 'ENCODING_REVIEW'. cv_text = '문자 인코딩 확인 필요'.
    WHEN 'SYNTAX_NOT_REQUESTED'. cv_text = '문법 검사 미선택'.
    WHEN 'CONTEXT_REQUIRED'. cv_text = '주프로그램 문맥 필요'.
    WHEN 'BSP_CONTEXT_REQUIRED'. cv_text = 'BSP 생성 문맥 필요'.
    WHEN 'TEXT_ONLY_NOT_SYNTAX'. cv_text = '문자 해석만 확인'.
    WHEN 'NOT_CHECKED'. cv_text = '검사 미수행'.
    WHEN 'NO_EXTRACT_TARGET'. cv_text = '추출본 없음·검사 대상 없음'.
    WHEN 'DIAGNOSTIC_ONLY'. cv_text = '진단 자료'.
    WHEN 'IDENTICAL_NOT_TESTED'. cv_text = '내용 일치·검사 생략'.
    WHEN 'MANUAL_MAPPING_REQUIRED'. cv_text = '객체 연결 확인 필요'.
    WHEN 'NOT_APPLICABLE' OR 'N/A'. cv_text = '해당 없음'.
    WHEN 'SYNTAX_PRECHECK_OK'. cv_text = '문법 사전검사 통과'.
    WHEN 'SYNTAX_PRECHECK_ERROR'. cv_text = '문법 사전검사 오류'.
    WHEN 'EOL_OR_BOM_ONLY'. cv_text = '개행 또는 BOM만 다름'.
    WHEN 'VER_SOURCE_LINK'. cv_text = '활성 소스 연결 확인'.
    WHEN 'VER_INTERFACE_ACTIVE'. cv_text = '활성 인터페이스 일치'.
    WHEN 'VER_FLAGS_ACTIVE'. cv_text = '활성 처리속성 일치'.
    WHEN 'VER_DEFINITION_DIFF'. cv_text = '활성 정의와 값 다름'.
    WHEN 'XML_BYTES_EQUAL'. cv_text = '전체 바이트 일치'.
    WHEN 'XML_VALUES_EQUAL'. cv_text = '항목·값 일치(표현 차이)'.
    WHEN 'XML_VALUES_DIFFERENT'. cv_text = '항목·값 불일치'.
    WHEN 'XML_NO_PAIR'. cv_text = '비교 파일 없음'.
    WHEN 'XML_REVIEW'. cv_text = '항목 비교 미완료'.
    WHEN 'INFO'. cv_text = '참고'.
    WHEN 'FAILED'. cv_text = '실패'.
    WHEN 'SKIPPED'. cv_text = '생략'.
    WHEN 'UNSUPPORTED'. cv_text = '미지원'.
    WHEN 'PARTIAL'. cv_text = '일부 처리'.
    WHEN 'EXPORTED'. cv_text = '조회 완료'.
    WHEN 'EXCLUDED'. cv_text = '제외'.
    WHEN 'FOLDER'. cv_text = '폴더'.
    WHEN 'REFERENCE_ONLY'. cv_text = '참조'.
  ENDCASE.
ENDFORM.

FORM im_tri_kind USING pv_base TYPE string pv_side TYPE string
                      pv_hbase TYPE c pv_hside TYPE c pv_base_ok TYPE c pv_side_ok TYPE c
                CHANGING cv_kind TYPE csequence.
  CLEAR cv_kind.
  IF pv_base_ok IS INITIAL OR pv_side_ok IS INITIAL. RETURN. ENDIF.
  IF pv_hbase IS INITIAL AND pv_hside = 'X'. cv_kind = '신규'.
  ELSEIF pv_hbase = 'X' AND pv_hside IS INITIAL. cv_kind = '누락'.
  ELSEIF pv_hbase = 'X' AND pv_hside = 'X'.
    cv_kind = '변경없음'.
    IF pv_base <> pv_side. cv_kind = '수정'. ENDIF.
  ENDIF.
ENDFORM.

FORM im_tri_emit USING pv_section TYPE csequence pv_block TYPE i
                      pv_ap TYPE csequence pv_a TYPE string pv_ha TYPE c
                      pv_bp TYPE csequence pv_b TYPE string pv_hb TYPE c
                      pv_cp TYPE csequence pv_c TYPE string pv_hc TYPE c
                      pv_bkind TYPE csequence pv_ckind TYPE csequence.
* Classic GUI ALV: keep chunks within 128 display characters per cell.
  DATA: ls_row TYPE im_view_row, lv_a TYPE string, lv_b TYPE string, lv_c TYPE string,
        lv_dkind TYPE c LENGTH 12, lv_bok TYPE c, lv_cok TYPE c, lv_info TYPE c,
        lv_n TYPE i, lv_take TYPE i, lv_part TYPE i, lv_count TYPE i, lv_long TYPE c.
  IF im_view_limited = 'X'. RETURN. ENDIF.
  IF pv_bkind = '안내' OR pv_bkind = '경로' OR pv_bkind = '생략'. lv_info = 'X'. ENDIF.
  IF lv_info IS INITIAL.
    IF im_view_result-b_state = 'P' OR im_view_result-b_state = 'N'. lv_bok = 'X'. ENDIF.
    IF im_view_result-c_state = 'P' OR im_view_result-c_state = 'N'. lv_cok = 'X'. ENDIF.
    PERFORM im_tri_kind USING pv_c pv_b pv_hc pv_hb lv_cok lv_bok CHANGING lv_dkind.
  ENDIF.
  IF pv_ha = 'X'. PERFORM im_view_value USING pv_a CHANGING lv_a.
  ELSE. lv_a = '(없음)'. ENDIF.
  IF pv_hb = 'X'. PERFORM im_view_value USING pv_b CHANGING lv_b.
  ELSE. lv_b = '(없음)'. ENDIF.
  IF pv_hc = 'X'. PERFORM im_view_value USING pv_c CHANGING lv_c.
  ELSE. lv_c = '(없음)'. ENDIF.
  IF lv_info IS INITIAL.
    IF im_view_result-a_state = 'U'. lv_a = '(원본 미확인)'. ENDIF.
    IF im_view_result-b_state = 'U'. lv_b = '(추출본 읽기 불가)'. ENDIF.
    IF im_view_result-c_state = 'U'. lv_c = '(SAP 미확인)'. ENDIF.
  ENDIF.
  IF strlen( lv_a ) > 128 OR strlen( lv_b ) > 128 OR strlen( lv_c ) > 128. lv_long = 'X'. ENDIF.
  WHILE lv_a IS NOT INITIAL OR lv_b IS NOT INITIAL OR lv_c IS NOT INITIAL.
    DESCRIBE TABLE im_view LINES lv_count.
    IF lv_count >= 12000. im_view_limited = 'X'. EXIT. ENDIF.
    CLEAR ls_row. ADD 1 TO lv_part.
    ls_row-seq = lv_count + 1.
    IF lv_long = 'X'. ls_row-part = lv_part. ENDIF.
    ls_row-section = pv_section. ls_row-block = pv_block.
    ls_row-base_pos = pv_ap. ls_row-zip_pos = pv_bp. ls_row-sap_pos = pv_cp.
    IF lv_info IS INITIAL.
      ls_row-zip_kind = pv_bkind. ls_row-sap_kind = pv_ckind.
      ls_row-zip_sap_kind = lv_dkind.
    ELSEIF pv_bkind = '경로'.
      CONCATENATE pv_section '경로' INTO ls_row-section SEPARATED BY space.
    ELSEIF pv_bkind = '생략'. ls_row-section = '소스 생략'. ENDIF.
    IF pv_bkind = '안내' OR pv_bkind = '경로' OR pv_bkind = '생략'.
      ls_row-color = 'C410'.
    ELSEIF pv_bkind = '신규' OR pv_ckind = '신규' OR lv_dkind = '신규'. ls_row-color = 'C510'.
    ELSEIF pv_bkind = '누락' OR pv_ckind = '누락' OR lv_dkind = '누락'. ls_row-color = 'C610'. ENDIF.
    IF pv_bkind = '수정' OR pv_ckind = '수정' OR lv_dkind = '수정' OR
       ( pv_bkind = '신규' AND pv_ckind = '누락' ) OR
       ( pv_bkind = '누락' AND pv_ckind = '신규' ). ls_row-color = 'C310'. ENDIF.
    lv_n = strlen( lv_a ). lv_take = lv_n. IF lv_take > 128. lv_take = 128. ENDIF.
    IF lv_take > 0. ls_row-base_text = lv_a(lv_take). lv_a = lv_a+lv_take. ENDIF.
    lv_n = strlen( lv_b ). lv_take = lv_n. IF lv_take > 128. lv_take = 128. ENDIF.
    IF lv_take > 0. ls_row-zip_text = lv_b(lv_take). lv_b = lv_b+lv_take. ENDIF.
    lv_n = strlen( lv_c ). lv_take = lv_n. IF lv_take > 128. lv_take = 128. ENDIF.
    IF lv_take > 0. ls_row-sap_text = lv_c(lv_take). lv_c = lv_c+lv_take. ENDIF.
    APPEND ls_row TO im_view.
  ENDWHILE.
ENDFORM.

FORM im_view_note USING pv_section TYPE csequence pv_text TYPE csequence.
  DATA lv_text TYPE string.
  lv_text = pv_text.
  REPLACE ALL OCCURRENCES OF 'BASELINE' IN lv_text WITH '원본'.
  REPLACE ALL OCCURRENCES OF 'ZIP' IN lv_text WITH '추출본'.
  PERFORM im_tri_emit USING pv_section 0 space lv_text 'X'
    space lv_text 'X' space lv_text 'X' '안내' '안내'.
ENDFORM.

FORM im_tri_align USING pt_base TYPE ty_lines pt_side TYPE ty_lines
                  CHANGING ct_map TYPE im_side_rows cv_note TYPE string.
* Build a complete baseline-indexed map from the existing bounded LCS.
* A replacement block is paired in order; surplus additions use slots
* after its last baseline line. This is alignment, never a merge action.
  DATA: lt_diff TYPE im_diffs, lt_old TYPE im_diffs, lt_new TYPE im_diffs,
        ls_diff TYPE im_diff, ls_old TYPE im_diff, ls_new TYPE im_diff,
        ls_map TYPE im_side_row, lv_i TYPE i, lv_count TYPE i,
        lv_a TYPE i, lv_b TYPE i, lv_na TYPE i, lv_nb TYPE i,
        lv_j TYPE i, lv_nold TYPE i, lv_nnew TYPE i,
        lv_anchor TYPE i, lv_slot TYPE i, lv_fill TYPE c.
  REFRESH ct_map. CLEAR cv_note.
  PERFORM im_diff_lines USING pt_base pt_side CHANGING lt_diff cv_note.
  DESCRIBE TABLE pt_base LINES lv_na. DESCRIBE TABLE pt_side LINES lv_nb.
  DESCRIBE TABLE lt_diff LINES lv_count. lv_i = 1. lv_a = 1. lv_b = 1.
  WHILE lv_i <= lv_count.
    READ TABLE lt_diff INTO ls_diff INDEX lv_i.
* Restore equal prefix rows omitted by the pairwise detail generator.
    DO.
      CLEAR lv_fill.
      IF ls_diff-old_line > 0 AND lv_a < ls_diff-old_line. lv_fill = 'X'. ENDIF.
      IF ls_diff-old_line = 0 AND ls_diff-new_line > 0 AND
         lv_b < ls_diff-new_line. lv_fill = 'X'. ENDIF.
      IF lv_fill IS INITIAL OR lv_a > lv_na OR lv_b > lv_nb. EXIT. ENDIF.
      CLEAR ls_map. ls_map-anchor = lv_a. ls_map-side_line = lv_b. ls_map-present = 'X'.
      READ TABLE pt_side INTO ls_map-text INDEX lv_b. INSERT ls_map INTO TABLE ct_map.
      ADD 1 TO lv_a. ADD 1 TO lv_b.
    ENDDO.
    IF ls_diff-kind IS INITIAL.
      CLEAR ls_map. ls_map-anchor = ls_diff-old_line.
      ls_map-side_line = ls_diff-new_line. ls_map-present = 'X'. ls_map-text = ls_diff-text.
      INSERT ls_map INTO TABLE ct_map.
      lv_a = ls_diff-old_line + 1. lv_b = ls_diff-new_line + 1. ADD 1 TO lv_i.
      CONTINUE.
    ENDIF.
    REFRESH: lt_old, lt_new.
    WHILE lv_i <= lv_count.
      READ TABLE lt_diff INTO ls_diff INDEX lv_i.
      IF ls_diff-kind IS INITIAL. EXIT. ENDIF.
      IF ls_diff-kind = '-'. APPEND ls_diff TO lt_old.
      ELSE. APPEND ls_diff TO lt_new. ENDIF.
      ADD 1 TO lv_i.
    ENDWHILE.
    DESCRIBE TABLE lt_old LINES lv_nold. DESCRIBE TABLE lt_new LINES lv_nnew.
    lv_anchor = lv_a - 1. lv_j = 1.
    LOOP AT lt_old INTO ls_old.
      CLEAR ls_map. ls_map-anchor = ls_old-old_line. lv_anchor = ls_old-old_line.
      READ TABLE lt_new INTO ls_new INDEX lv_j.
      IF sy-subrc = 0.
        ls_map-present = 'X'. ls_map-side_line = ls_new-new_line. ls_map-text = ls_new-text.
      ENDIF.
      INSERT ls_map INTO TABLE ct_map. ADD 1 TO lv_j.
    ENDLOOP.
    lv_j = lv_nold + 1. lv_slot = 0.
    WHILE lv_j <= lv_nnew.
      READ TABLE lt_new INTO ls_new INDEX lv_j. CLEAR ls_map. ADD 1 TO lv_slot.
      ls_map-anchor = lv_anchor. ls_map-slot = lv_slot. ls_map-present = 'X'.
      ls_map-side_line = ls_new-new_line. ls_map-text = ls_new-text.
      INSERT ls_map INTO TABLE ct_map. ADD 1 TO lv_j.
    ENDWHILE.
    ADD lv_nold TO lv_a. ADD lv_nnew TO lv_b.
  ENDWHILE.
* Equal suffix (or a wholly unchanged file).
  WHILE lv_a <= lv_na.
    CLEAR ls_map. ls_map-anchor = lv_a.
    READ TABLE pt_side INTO ls_map-text INDEX lv_b.
    IF sy-subrc = 0. ls_map-present = 'X'. ls_map-side_line = lv_b. ADD 1 TO lv_b. ENDIF.
    INSERT ls_map INTO TABLE ct_map. ADD 1 TO lv_a.
  ENDWHILE.
ENDFORM.

FORM im_tri_source USING pt_a TYPE ty_lines pt_b TYPE ty_lines pt_c TYPE ty_lines
                        pv_ao TYPE c pv_bo TYPE c pv_co TYPE c.
  DATA: lt_b TYPE im_side_rows, lt_c TYPE im_side_rows,
        lt_keys TYPE im_side_keys, ls_key TYPE im_side_key,
        ls_b TYPE im_side_row, ls_c TYPE im_side_row,
        lt_rows TYPE im_logic_rows, ls_row TYPE im_logic_row,
        lv_text TYPE string, lv_note TYPE string, lv_a TYPE string,
        lv_ha TYPE c, lv_i TYPE i, lv_j TYPE i, lv_n TYPE i, lv_run TYPE i,
        lv_max TYPE i, lv_nb TYPE i, lv_nc TYPE i, lv_omit TYPE i, lv_last TYPE i,
        lv_ap TYPE c LENGTH 12, lv_bp TYPE c LENGTH 12, lv_cp TYPE c LENGTH 12,
        lv_num TYPE c LENGTH 12, lv_bkind TYPE c LENGTH 12, lv_ckind TYPE c LENGTH 12.
  IF pv_ao = 'X' AND im_view_result-a_state <> 'N'.
    IF pv_bo = 'X'.
      PERFORM im_tri_align USING pt_a pt_b CHANGING lt_b lv_note.
      IF lv_note IS NOT INITIAL.
        CONCATENATE '추출본/원본:' lv_note INTO lv_text SEPARATED BY space.
        PERFORM im_view_note USING '소스' lv_text.
      ENDIF.
    ENDIF.
    IF pv_co = 'X'.
      PERFORM im_tri_align USING pt_a pt_c CHANGING lt_c lv_note.
      IF lv_note IS NOT INITIAL.
        CONCATENATE 'SAP/원본:' lv_note INTO lv_text SEPARATED BY space.
        PERFORM im_view_note USING '소스' lv_text.
      ENDIF.
    ENDIF.
    DESCRIBE TABLE pt_a LINES lv_n.
    DO lv_n TIMES. CLEAR ls_key. ls_key-anchor = sy-index. INSERT ls_key INTO TABLE lt_keys. ENDDO.
    LOOP AT lt_b INTO ls_b.
      ls_key-anchor = ls_b-anchor. ls_key-slot = ls_b-slot. INSERT ls_key INTO TABLE lt_keys.
    ENDLOOP.
    LOOP AT lt_c INTO ls_c.
      ls_key-anchor = ls_c-anchor. ls_key-slot = ls_c-slot. INSERT ls_key INTO TABLE lt_keys.
    ENDLOOP.
    LOOP AT lt_keys INTO ls_key.
      CLEAR: ls_row, lv_a, lv_ha, ls_b, ls_c.
      IF ls_key-slot = 0 AND ls_key-anchor > 0.
        READ TABLE pt_a INTO lv_a INDEX ls_key-anchor.
        IF sy-subrc = 0. lv_ha = 'X'. ls_row-base_line = ls_key-anchor. ENDIF.
      ENDIF.
      READ TABLE lt_b INTO ls_b WITH TABLE KEY anchor = ls_key-anchor slot = ls_key-slot.
      READ TABLE lt_c INTO ls_c WITH TABLE KEY anchor = ls_key-anchor slot = ls_key-slot.
      ls_row-base_text = lv_a. ls_row-hbase = lv_ha.
      ls_row-zip_text = ls_b-text. ls_row-hzip = ls_b-present. ls_row-zip_line = ls_b-side_line.
      ls_row-sap_text = ls_c-text. ls_row-hsap = ls_c-present. ls_row-sap_line = ls_c-side_line.
      PERFORM im_tri_kind USING lv_a ls_b-text lv_ha ls_b-present pv_ao pv_bo
        CHANGING ls_row-zip_kind.
      PERFORM im_tri_kind USING lv_a ls_c-text lv_ha ls_c-present pv_ao pv_co
        CHANGING ls_row-sap_kind.
      APPEND ls_row TO lt_rows.
    ENDLOOP.
  ELSE.
* SAP is the anchor when no readable original exists. A known absent
* original still permits NEW; an unverified original leaves its pairs blank.
    IF pv_co = 'X' AND pv_bo = 'X'.
      PERFORM im_tri_align USING pt_c pt_b CHANGING lt_b lv_note.
      IF lv_note IS NOT INITIAL. PERFORM im_view_note USING '소스' lv_note. ENDIF.
      LOOP AT lt_b INTO ls_b.
        CLEAR ls_row.
        IF ls_b-slot = 0 AND ls_b-anchor > 0.
          READ TABLE pt_c INTO ls_row-sap_text INDEX ls_b-anchor.
          IF sy-subrc = 0. ls_row-hsap = 'X'. ls_row-sap_line = ls_b-anchor. ENDIF.
        ENDIF.
        ls_row-zip_text = ls_b-text. ls_row-hzip = ls_b-present.
        ls_row-zip_line = ls_b-side_line.
        PERFORM im_tri_kind USING ls_row-base_text ls_row-zip_text
          space ls_row-hzip pv_ao pv_bo CHANGING ls_row-zip_kind.
        PERFORM im_tri_kind USING ls_row-base_text ls_row-sap_text
          space ls_row-hsap pv_ao pv_co CHANGING ls_row-sap_kind.
        APPEND ls_row TO lt_rows.
      ENDLOOP.
    ELSE.
      DESCRIBE TABLE pt_b LINES lv_nb. DESCRIBE TABLE pt_c LINES lv_nc.
      lv_max = lv_nb. IF lv_nc > lv_max. lv_max = lv_nc. ENDIF.
      DO lv_max TIMES.
        lv_i = sy-index. CLEAR ls_row.
        READ TABLE pt_b INTO ls_row-zip_text INDEX lv_i.
        IF sy-subrc = 0. ls_row-hzip = 'X'. ls_row-zip_line = lv_i. ENDIF.
        READ TABLE pt_c INTO ls_row-sap_text INDEX lv_i.
        IF sy-subrc = 0. ls_row-hsap = 'X'. ls_row-sap_line = lv_i. ENDIF.
        PERFORM im_tri_kind USING ls_row-base_text ls_row-zip_text
          space ls_row-hzip pv_ao pv_bo CHANGING ls_row-zip_kind.
        PERFORM im_tri_kind USING ls_row-base_text ls_row-sap_text
          space ls_row-hsap pv_ao pv_co CHANGING ls_row-sap_kind.
        APPEND ls_row TO lt_rows.
      ENDDO.
    ENDIF.
  ENDIF.
  DESCRIBE TABLE lt_rows LINES lv_n. lv_i = 1.
  WHILE lv_i <= lv_n AND im_view_limited IS INITIAL.
    READ TABLE lt_rows INTO ls_row INDEX lv_i.
* Retain three context lines at each end of a long unchanged run.
    IF ls_row-zip_kind = '변경없음' AND ls_row-sap_kind = '변경없음'.
      lv_j = lv_i.
      WHILE lv_j <= lv_n.
        READ TABLE lt_rows INTO ls_row INDEX lv_j.
        IF ls_row-zip_kind <> '변경없음' OR ls_row-sap_kind <> '변경없음'. EXIT. ENDIF.
        ADD 1 TO lv_j.
      ENDWHILE.
      lv_run = lv_j - lv_i.
    ELSE. lv_run = 1. ENDIF.
    lv_last = lv_run - 3.
    DO lv_run TIMES.
      IF lv_run > 6 AND sy-index > 3 AND sy-index <= lv_last.
        IF sy-index = 4.
          lv_omit = lv_run - 6. WRITE lv_omit TO lv_num NO-GROUPING. CONDENSE lv_num.
          CONCATENATE '세 버전 동일한 중간' lv_num '줄 생략' INTO lv_text SEPARATED BY space.
          PERFORM im_tri_emit USING '소스' 0 space lv_text 'X' space lv_text 'X'
            space lv_text 'X' '생략' '생략'.
        ENDIF.
      ELSE.
        READ TABLE lt_rows INTO ls_row INDEX lv_i. CLEAR: lv_ap, lv_bp, lv_cp.
        IF ls_row-hbase = 'X'. WRITE ls_row-base_line TO lv_ap NO-GROUPING. CONDENSE lv_ap. ENDIF.
        IF ls_row-hzip = 'X'. WRITE ls_row-zip_line TO lv_bp NO-GROUPING. CONDENSE lv_bp. ENDIF.
        IF ls_row-hsap = 'X'. WRITE ls_row-sap_line TO lv_cp NO-GROUPING. CONDENSE lv_cp. ENDIF.
        PERFORM im_tri_emit USING '소스' 0 lv_ap ls_row-base_text ls_row-hbase
          lv_bp ls_row-zip_text ls_row-hzip lv_cp ls_row-sap_text ls_row-hsap
          ls_row-zip_kind ls_row-sap_kind.
      ENDIF.
      ADD 1 TO lv_i. IF im_view_limited = 'X'. EXIT. ENDIF.
    ENDDO.
  ENDWHILE.
ENDFORM.

FORM im_tri_xml USING pv_a TYPE xstring pv_b TYPE xstring pv_c TYPE xstring
                     pv_ao TYPE c pv_bo TYPE c pv_co TYPE c pv_generated TYPE c.
* Element nodes track structure; direct text/attributes track values.
* A leaf change must not appear again at every ancestor element.
  DATA: lt_a TYPE im_xml_nodes, lt_b TYPE im_xml_nodes, lt_c TYPE im_xml_nodes,
        lt_paths TYPE im_paths, lv_path TYPE string, lv_error TYPE string,
        ls_a TYPE im_xml_node, ls_b TYPE im_xml_node, ls_c TYPE im_xml_node,
        lv_ha TYPE c, lv_hb TYPE c, lv_hc TYPE c, lv_found TYPE c,
        lv_ak TYPE c, lv_bk TYPE c, lv_ck TYPE c,
        lv_bkind TYPE c LENGTH 12, lv_ckind TYPE c LENGTH 12,
        lv_scope TYPE c LENGTH 24.
  lv_ak = pv_ao. lv_bk = pv_bo. lv_ck = pv_co.
  IF im_view_result-a_state = 'N'. lv_ak = 'X'. ENDIF.
  IF im_view_result-b_state = 'N'. lv_bk = 'X'. ENDIF.
  IF im_view_result-c_state = 'N'. lv_ck = 'X'. ENDIF.
  IF pv_ao = 'X'. PERFORM im_xml_index USING pv_a pv_generated CHANGING lt_a lv_error. ENDIF.
  IF lv_error IS INITIAL AND pv_bo = 'X'.
    PERFORM im_xml_index USING pv_b pv_generated CHANGING lt_b lv_error.
  ENDIF.
  IF lv_error IS INITIAL AND pv_co = 'X'.
    PERFORM im_xml_index USING pv_c pv_generated CHANGING lt_c lv_error.
  ENDIF.
  IF lv_error IS NOT INITIAL. PERFORM im_view_note USING 'XML' lv_error. RETURN. ENDIF.
  PERFORM im_view_note USING 'XML'
    '항목 경로의 [n]은 형제 순번, @는 속성, #16은 텍스트입니다. 반복 항목 재정렬은 후속 경로에 영향을 줄 수 있습니다.'.
  LOOP AT lt_a INTO ls_a. INSERT ls_a-path INTO TABLE lt_paths. ENDLOOP.
  LOOP AT lt_b INTO ls_b. INSERT ls_b-path INTO TABLE lt_paths. ENDLOOP.
  LOOP AT lt_c INTO ls_c. INSERT ls_c-path INTO TABLE lt_paths. ENDLOOP.
  LOOP AT lt_paths INTO lv_path.
    CLEAR: ls_a, ls_b, ls_c, lv_ha, lv_hb, lv_hc.
    READ TABLE lt_a INTO ls_a WITH TABLE KEY path = lv_path. IF sy-subrc = 0. lv_ha = 'X'. ENDIF.
    READ TABLE lt_b INTO ls_b WITH TABLE KEY path = lv_path. IF sy-subrc = 0. lv_hb = 'X'. ENDIF.
    READ TABLE lt_c INTO ls_c WITH TABLE KEY path = lv_path. IF sy-subrc = 0. lv_hc = 'X'. ENDIF.
    PERFORM im_tri_kind USING ls_a-value ls_b-value lv_ha lv_hb lv_ak lv_bk CHANGING lv_bkind.
    PERFORM im_tri_kind USING ls_a-value ls_c-value lv_ha lv_hc lv_ak lv_ck CHANGING lv_ckind.
    IF lv_bkind = '변경없음' AND lv_ckind = '변경없음'. CONTINUE. ENDIF.
    lv_found = 'X'. ADD 1 TO im_view_group.
    PERFORM im_xml_scope USING im_view_result lv_path CHANGING lv_scope.
    PERFORM im_tri_emit USING lv_scope im_view_group space lv_path 'X'
      space lv_path 'X' space lv_path 'X' '경로' '경로'.
    PERFORM im_tri_emit USING lv_scope im_view_group '값' ls_a-value lv_ha
      '값' ls_b-value lv_hb '값' ls_c-value lv_hc lv_bkind lv_ckind.
    IF im_view_limited = 'X'. EXIT. ENDIF.
  ENDLOOP.
  IF lv_found IS INITIAL.
    PERFORM im_view_note USING 'XML'
      '분석한 XML 항목 경로와 값은 같습니다. 아래 원문 비교에서 표현·순서 등의 차이를 확인하십시오.'.
  ENDIF.
ENDFORM.

FORM im_tri_binary USING pv_a TYPE xstring pv_b TYPE xstring pv_c TYPE xstring
                        pv_ao TYPE c pv_bo TYPE c pv_co TYPE c.
  DATA: lv_al TYPE i, lv_bl TYPE i, lv_cl TYPE i, lv_max TYPE i, lv_at TYPE i,
        lv_take TYPE i, lv_count TYPE i, lv_ax TYPE xstring, lv_bx TYPE xstring,
        lv_cx TYPE xstring, lv_a TYPE string, lv_b TYPE string, lv_c TYPE string,
        lv_ha TYPE c, lv_hb TYPE c, lv_hc TYPE c, lv_pos TYPE c LENGTH 12,
        lv_bkind TYPE c LENGTH 12, lv_ckind TYPE c LENGTH 12.
  PERFORM im_view_note USING '바이트'
    '위치는 0부터 시작하는 바이트 오프셋입니다. 같은 위치의 16바이트 HEX를 비교하며, 이미지의 시각적 변화는 분석하지 않습니다.'.
  IF pv_ao = 'X'. lv_al = xstrlen( pv_a ). ENDIF.
  IF pv_bo = 'X'. lv_bl = xstrlen( pv_b ). ENDIF.
  IF pv_co = 'X'. lv_cl = xstrlen( pv_c ). ENDIF.
  lv_max = lv_al. IF lv_bl > lv_max. lv_max = lv_bl. ENDIF.
  IF lv_cl > lv_max. lv_max = lv_cl. ENDIF.
  WHILE lv_at < lv_max AND im_view_limited IS INITIAL.
    CLEAR: lv_ax, lv_bx, lv_cx, lv_ha, lv_hb, lv_hc.
    IF lv_at < lv_al.
      lv_take = lv_al - lv_at. IF lv_take > 16. lv_take = 16. ENDIF.
      lv_ax = pv_a+lv_at(lv_take). lv_ha = 'X'.
    ENDIF.
    IF lv_at < lv_bl.
      lv_take = lv_bl - lv_at. IF lv_take > 16. lv_take = 16. ENDIF.
      lv_bx = pv_b+lv_at(lv_take). lv_hb = 'X'.
    ENDIF.
    IF lv_at < lv_cl.
      lv_take = lv_cl - lv_at. IF lv_take > 16. lv_take = 16. ENDIF.
      lv_cx = pv_c+lv_at(lv_take). lv_hc = 'X'.
    ENDIF.
    lv_a = lv_ax. lv_b = lv_bx. lv_c = lv_cx.
    PERFORM im_tri_kind USING lv_a lv_b lv_ha lv_hb pv_ao pv_bo CHANGING lv_bkind.
    PERFORM im_tri_kind USING lv_a lv_c lv_ha lv_hc pv_ao pv_co CHANGING lv_ckind.
    IF lv_bkind <> '변경없음' OR lv_ckind <> '변경없음'.
      ADD 1 TO lv_count.
      IF lv_count > 256.
        PERFORM im_view_note USING '바이트'
          'DISPLAY_LIMIT: 변경된 첫 256개 바이트 구간까지 표시합니다. 파일 전체 일치 판정은 별도로 수행됩니다.'. EXIT.
      ENDIF.
      WRITE lv_at TO lv_pos NO-GROUPING. CONDENSE lv_pos.
      PERFORM im_tri_emit USING '바이트' 0 lv_pos lv_a lv_ha lv_pos lv_b lv_hb
        lv_pos lv_c lv_hc lv_bkind lv_ckind.
    ENDIF.
    ADD 16 TO lv_at.
  ENDWHILE.
ENDFORM.

FORM im_tri_build USING ps_result TYPE im_result.
  DATA: ls_file TYPE ty_file, ls_blob TYPE im_blob, lv_path TYPE string,
        lv_a TYPE xstring, lv_b TYPE xstring, lv_c TYPE xstring,
        lv_ao TYPE c, lv_bo TYPE c, lv_co TYPE c,
        lv_ak TYPE c, lv_bk TYPE c, lv_ck TYPE c,
        lv_at TYPE string, lv_bt TYPE string, lv_ct TYPE string,
        lv_error TYPE string, lv_note TYPE string, lv_text TYPE string,
        lt_a TYPE ty_lines, lt_b TYPE ty_lines, lt_c TYPE ty_lines,
        lv_generated TYPE c, lv_size TYPE i, lv_as TYPE c LENGTH 16,
        lv_bs TYPE c LENGTH 16, lv_cs TYPE c LENGTH 16,
        lv_same_b TYPE c, lv_same_c TYPE c.
  IF ps_result-comparison = 'OUT_OF_SCOPE' OR ps_result-comparison = 'MAPPING_REJECTED'.
    PERFORM im_view_note USING '안내' '추출 범위 밖이거나 객체 매핑이 거부된 항목입니다.'. RETURN.
  ENDIF.
  lv_path = ps_result-path.
  READ TABLE im_manifest_index INTO ls_file WITH TABLE KEY path = lv_path.
  IF sy-subrc = 0.
    PERFORM im_triplet USING ls_file CHANGING lv_a lv_b lv_c lv_ao lv_bo lv_co.
  ELSE.
    PERFORM im_get USING im_zip_b im_entries_b lv_path CHANGING lv_b lv_bo.
    READ TABLE im_current INTO ls_blob WITH TABLE KEY path = lv_path.
    IF sy-subrc = 0. lv_c = ls_blob-data. lv_co = 'X'. ENDIF.
    READ TABLE im_current_index INTO ls_file WITH TABLE KEY path = lv_path.
  ENDIF.
  PERFORM im_byte_label USING ps_result-a_state ps_result-bytes_a CHANGING im_view_bytes_a.
  PERFORM im_byte_label USING ps_result-b_state ps_result-bytes_b CHANGING im_view_bytes_b.
  PERFORM im_byte_label USING ps_result-c_state ps_result-bytes_c CHANGING im_view_bytes_c.
  IF ps_result-pair_note IS NOT INITIAL. PERFORM im_view_note USING '비교 안내' ps_result-pair_note. ENDIF.
  lv_ak = lv_ao. lv_bk = lv_bo. lv_ck = lv_co.
  IF ps_result-a_state = 'N'. lv_ak = 'X'. ENDIF.
  IF ps_result-b_state = 'N'. lv_bk = 'X'. ENDIF.
  IF ps_result-c_state = 'N'. lv_ck = 'X'. ENDIF.
  IF lv_ao = 'X' AND lv_bo = 'X' AND lv_co = 'X' AND lv_a = lv_b AND lv_a = lv_c.
    PERFORM im_view_note USING '안내' '내용 일치: 원본·추출본·SAP 세 파일의 전체 바이트가 같습니다.'. RETURN.
  ENDIF.
  IF lv_ao = 'X'. PERFORM im_decode USING lv_a CHANGING lv_at lv_error. ENDIF.
  IF lv_error IS INITIAL AND lv_bo = 'X'. PERFORM im_decode USING lv_b CHANGING lv_bt lv_error. ENDIF.
  IF lv_error IS INITIAL AND lv_co = 'X'. PERFORM im_decode USING lv_c CHANGING lv_ct lv_error. ENDIF.
  TRANSLATE lv_path TO LOWER CASE.
  IF ls_file-component = 'MIME_CONTENT' OR ls_file-component = 'W3MI_CONTENT'.
    IF lv_path NP '*.xml' AND lv_path NP '*.js' AND lv_path NP '*.css' AND
       lv_path NP '*.htm' AND lv_path NP '*.html' AND lv_path NP '*.svg' AND
       lv_path NP '*.json' AND lv_path NP '*.txt' AND lv_path NP '*.csv'. lv_error = 'Binary asset'. ENDIF.
  ENDIF.
  IF lv_error IS NOT INITIAL.
    PERFORM im_tri_binary USING lv_a lv_b lv_c lv_ak lv_bk lv_ck. RETURN.
  ENDIF.
  IF lv_ao = 'X' AND lv_bo = 'X'.
    PERFORM im_format_note USING lv_a lv_b CHANGING lv_note.
    IF lv_note IS NOT INITIAL.
      PERFORM im_status_text USING lv_note CHANGING lv_text.
      CONCATENATE '추출본/원본:' lv_text INTO lv_text SEPARATED BY space.
      PERFORM im_view_note USING '형식' lv_text.
    ENDIF.
  ENDIF.
  IF lv_ao = 'X' AND lv_co = 'X'.
    PERFORM im_format_note USING lv_a lv_c CHANGING lv_note.
    IF lv_note IS NOT INITIAL.
      PERFORM im_status_text USING lv_note CHANGING lv_text.
      CONCATENATE 'SAP/원본:' lv_text INTO lv_text SEPARATED BY space.
      PERFORM im_view_note USING '형식' lv_text.
    ENDIF.
  ENDIF.
  IF lv_path CP '*.xml' OR lv_path CP '*.svg'.
    IF ls_file-check_mode = 'LF_UTF8'. lv_generated = 'X'. ENDIF.
    PERFORM im_tri_xml USING lv_a lv_b lv_c lv_ao lv_bo lv_co lv_generated.
  ENDIF.
  IF lv_ao = 'X'. PERFORM im_split USING lv_at CHANGING lt_a lv_error. ENDIF.
  IF lv_error IS INITIAL AND lv_bo = 'X'. PERFORM im_split USING lv_bt CHANGING lt_b lv_error. ENDIF.
  IF lv_error IS INITIAL AND lv_co = 'X'. PERFORM im_split USING lv_ct CHANGING lt_c lv_error. ENDIF.
  IF lv_error IS NOT INITIAL. PERFORM im_view_note USING '소스' lv_error. RETURN. ENDIF.
  PERFORM im_tri_source USING lt_a lt_b lt_c lv_ak lv_bk lv_ck.
* Preserve evidence when line splitting hides EOL/BOM/final-newline bytes.
  IF lv_ao = 'X' AND lv_bo = 'X' AND lt_a = lt_b AND lv_a <> lv_b. lv_same_b = 'X'. ENDIF.
  IF lv_ao = 'X' AND lv_co = 'X' AND lt_a = lt_c AND lv_a <> lv_c. lv_same_c = 'X'. ENDIF.
  IF lv_same_b = 'X' OR lv_same_c = 'X'.
    PERFORM im_view_note USING '형식' '줄 내용은 동일합니다. 개행, BOM 또는 마지막 개행의 바이트 차이를 표시합니다.'.
    PERFORM im_tri_binary USING lv_a lv_b lv_c lv_ak lv_bk lv_ck.
  ENDIF.
ENDFORM.

FORM im_view_column USING pv_field TYPE csequence pv_title TYPE csequence pv_width TYPE i
                    CHANGING ct_fcat TYPE slis_t_fieldcat_alv.
  DATA ls_field TYPE slis_fieldcat_alv.
  ls_field-fieldname = pv_field. ls_field-seltext_l = pv_title.
  ls_field-seltext_m = pv_title. ls_field-seltext_s = pv_title. ls_field-outputlen = pv_width.
  IF pv_field = 'BLOCK' OR pv_field = 'PART'. ls_field-no_zero = 'X'. ENDIF.
  IF pv_field = 'SEQ' OR pv_field = 'ZIP_KIND' OR pv_field = 'SAP_KIND' OR
     pv_field = 'ZIP_SAP_KIND'. ls_field-key = 'X'. ls_field-fix_column = 'X'. ENDIF.
  APPEND ls_field TO ct_fcat.
ENDFORM.



FORM im_view_command USING pv_ucomm LIKE sy-ucomm ps_selfield TYPE slis_selfield.
* Standard Back/Exit/Cancel belongs to this nested ALV call. Do not exit
* the parent grid or start another detail from a display fragment.
ENDFORM.

FORM im_detail_grid USING ps_result TYPE im_result.
  DATA: lt_fcat TYPE slis_t_fieldcat_alv, ls_layout TYPE slis_layout_alv,
        lv_title TYPE lvc_title, lv_num TYPE c LENGTH 12,
        lv_text TYPE string, ls_log TYPE ty_log, ls_row TYPE im_view_row, lv_count TYPE i,
        lv_status TYPE string.
  REFRESH im_view. CLEAR: im_view_limited, im_view_group.
  im_view_result = ps_result.
  im_view_bytes_a = '조회 안 함'. im_view_bytes_b = '조회 안 함'.
  im_view_bytes_c = '조회 안 함'.
  IF ps_result-xml_bc IS NOT INITIAL.
    CONCATENATE '추출본/원본:' ps_result-xml_ab_note INTO lv_text SEPARATED BY space.
    PERFORM im_view_note USING 'XML 비교' lv_text.
    CONCATENATE 'SAP/원본:' ps_result-xml_ac_note INTO lv_text SEPARATED BY space.
    PERFORM im_view_note USING 'XML 비교' lv_text.
    CONCATENATE 'SAP→추출본:' ps_result-xml_note INTO lv_text SEPARATED BY space.
    PERFORM im_view_note USING 'XML 비교' lv_text.
  ENDIF.
  PERFORM im_tri_build USING ps_result.
  PERFORM im_view_note USING '조회 결과' ps_result-read_note.
  PERFORM im_view_note USING '활성 버전 확인' ps_result-version_note.
  PERFORM im_view_note USING '검증' ps_result-message.
  IF ps_result-validation_note IS NOT INITIAL AND ps_result-validation_note <> ps_result-message.
    PERFORM im_view_note USING '문법형식' ps_result-validation_note.
  ENDIF.
  IF ps_result-error_line > 0.
    WRITE ps_result-error_line TO lv_num NO-GROUPING. CONDENSE lv_num.
    CONCATENATE ps_result-error_program '행' lv_num INTO lv_text SEPARATED BY space.
    PERFORM im_view_note USING '문법 위치' lv_text.
  ENDIF.
  LOOP AT gt_logs INTO ls_log WHERE object = ps_result-object AND obj_name = ps_result-obj_name.
    PERFORM im_status_text USING ls_log-status CHANGING lv_status.
    CONCATENATE ls_log-stage lv_status ls_log-component ls_log-detail INTO lv_text SEPARATED BY space.
    PERFORM im_view_note USING '진단' lv_text.
    IF im_view_limited = 'X'. EXIT. ENDIF.
  ENDLOOP.
  IF im_view_limited = 'X'.
    CLEAR ls_row. DESCRIBE TABLE im_view LINES lv_count. ls_row-seq = lv_count + 1.
    ls_row-section = '표시 한도'.
    ls_row-color = 'C610'. ls_row-base_text = 'DISPLAY_LIMIT: 상세 표시 12000행 한도에 도달했습니다.'.
    ls_row-zip_text = '표시되지 않은 나머지 내용이 있습니다. 전체 바이트 비교 판정은 유지됩니다.'.
    ls_row-sap_text = ls_row-zip_text. APPEND ls_row TO im_view.
  ENDIF.
  PERFORM im_view_column USING 'SEQ' '순서' 5 CHANGING lt_fcat.
  PERFORM im_view_column USING 'ZIP_KIND' '추출본/원본 대비' 12 CHANGING lt_fcat.
  PERFORM im_view_column USING 'SAP_KIND' 'SAP/원본 대비' 12 CHANGING lt_fcat.
  PERFORM im_view_column USING 'ZIP_SAP_KIND' '추출본/SAP 대비' 12 CHANGING lt_fcat.
  PERFORM im_view_column USING 'SECTION' '구분' 14 CHANGING lt_fcat.
  PERFORM im_view_column USING 'BASE_POS' '원본 행/위치' 8 CHANGING lt_fcat.
  PERFORM im_view_column USING 'BASE_TEXT' '원본' 40 CHANGING lt_fcat.
  PERFORM im_view_column USING 'ZIP_POS' '추출본 행/위치' 8 CHANGING lt_fcat.
  PERFORM im_view_column USING 'ZIP_TEXT' '추출본' 40 CHANGING lt_fcat.
  PERFORM im_view_column USING 'SAP_POS' 'SAP 행/위치' 8 CHANGING lt_fcat.
  PERFORM im_view_column USING 'SAP_TEXT' 'SAP' 40 CHANGING lt_fcat.
  PERFORM im_view_column USING 'PART' '순번' 4 CHANGING lt_fcat.
  PERFORM im_view_column USING 'BLOCK' '구간' 5 CHANGING lt_fcat.
  ls_layout-info_fieldname = 'COLOR'.
  lv_title = 'DEVHUB DIAG 0.7.1 - 원본 / 추출본 / 진단 시점 SAP 비교'.
* Release the current screen's header before entering the nested ALV.
* The main PBO callback rebuilds only its header after F3; no SAP reread.
  PERFORM im_header_free.
  PERFORM im_header_detail_data.
  im_screen_mode = 'D'. CLEAR im_toolbar_grid.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING i_callback_program = im_program
      i_callback_user_command = 'IM_VIEW_COMMAND'
      i_callback_pf_status_set = 'IM_DETAIL_STATUS'
      i_grid_title = lv_title is_layout = ls_layout it_fieldcat = lt_fcat
    TABLES t_outtab = im_view
    EXCEPTIONS program_error = 1 OTHERS = 2.
  IF sy-subrc <> 0. MESSAGE '상세 ALV 표시 실패. 결과 목록으로 돌아갑니다.' TYPE 'I'. ENDIF.
  PERFORM im_header_free.
  FREE im_view.
  CLEAR: im_view_result, im_view_bytes_a, im_view_bytes_b, im_view_bytes_c, im_toolbar_grid.
  im_screen_mode = 'M'.
ENDFORM.

FORM im_detail USING ps_result TYPE im_result pv_mode TYPE c.
  DATA: ls_file TYPE ty_file, lv_path TYPE string,
        lv_a TYPE xstring, lv_b TYPE xstring, lv_c TYPE xstring,
        lv_aok TYPE c, lv_bok TYPE c, lv_cok TYPE c,
        lv_old TYPE xstring, lv_new TYPE xstring,
        lv_text_old TYPE string, lv_text_new TYPE string,
        lv_error TYPE string, lv_error2 TYPE string,
        lt_old TYPE ty_lines, lt_new TYPE ty_lines, lt_diff TYPE im_diffs,
        ls_diff TYPE im_diff, lv_note TYPE string, lv_count TYPE i,
        lv_text TYPE string, lv_chunk TYPE c LENGTH 220,
        lv_left TYPE i, ls_log TYPE ty_log, lv_crc_old TYPE i,
        lv_crc_new TYPE i, lv_generated TYPE c.
  WRITE: / 'DEVHUB DIAG 0.7.1 / DIAGNOSIS SNAPSHOT',
    / 'File:', ps_result-path,
    / '추출본/SAP:', ps_result-comparison_text,
    / '추출본/원본:', ps_result-zip_change_text,
    / 'SAP/원본:', ps_result-sap_change_text,
    / '조회 결과:', ps_result-read_text, ps_result-read_note,
    / '활성 버전 확인 결과:', ps_result-version_text, ps_result-version_note,
    / '문법·형식 검증:', ps_result-validation_text,
    / 'Detail:', ps_result-message,
    / 'Syntax location:', ps_result-error_program, ps_result-error_line,
    / 'Baseline:', im_baseline_mode,
    / 'Snapshot:', im_started_date, im_started_time, '-', im_finished_time,
    / 'SAP reads are not an atomic snapshot. Recheck before any future write.'.
  ULINE.
  IF ps_result-comparison = 'OUT_OF_SCOPE' OR
     ps_result-comparison = 'MAPPING_REJECTED'.
    WRITE / 'No detail comparison for excluded/rejected mapping.'. RETURN.
  ENDIF.
  lv_path = ps_result-path.
  READ TABLE im_manifest_index INTO ls_file WITH TABLE KEY path = lv_path.
  IF sy-subrc <> 0.
    WRITE / 'Unmapped/SAP-only file: no original identity; manual review required.'.
    RETURN.
  ENDIF.
  PERFORM im_triplet USING ls_file CHANGING lv_a lv_b lv_c
    lv_aok lv_bok lv_cok.
  IF pv_mode = 'Z'.
    WRITE / '전 = 추출 원본 (.devhub/baseline) / 후 = ZIP packages'.
    IF lv_aok IS INITIAL OR lv_bok IS INITIAL.
      WRITE / '원본 기준의 CRC/길이 확인 또는 ZIP 읽기에 실패했습니다.'. RETURN.
    ENDIF.
    lv_old = lv_a. lv_new = lv_b.
  ELSEIF pv_mode = 'S'.
    WRITE / '전 = 현재 SAP / 후 = ZIP packages (반영 후보)'.
    IF lv_cok IS INITIAL OR lv_bok IS INITIAL.
      WRITE / '현재 SAP 또는 ZIP 내용을 읽지 못해 비교할 수 없습니다.'. RETURN.
    ENDIF.
    lv_old = lv_c. lv_new = lv_b.
  ELSE.
    WRITE / '전 = 추출 원본 (.devhub/baseline) / 후 = 현재 SAP'.
    IF lv_aok IS INITIAL OR lv_cok IS INITIAL.
      WRITE / '원본 기준의 CRC/길이 확인 또는 현재 SAP 읽기에 실패했습니다.'. RETURN.
    ENDIF.
    lv_old = lv_a. lv_new = lv_c.
  ENDIF.
  IF ps_result-version_state <> 'VER_ACTIVE'.
    WRITE / 'SAP 조회 상태를 확인하십시오. 내용 비교와 활성 버전 확인은 별개입니다.'.
  ENDIF.
  IF lv_old = lv_new.
    WRITE / '내용 동일: 전후 전체 바이트가 같습니다.'.
  ELSE.
    PERFORM im_decode USING lv_old CHANGING lv_text_old lv_error.
    PERFORM im_decode USING lv_new CHANGING lv_text_new lv_error2.
    lv_path = ls_file-path. TRANSLATE lv_path TO LOWER CASE.
* Binary assets must not be mistaken for text merely because UTF-8 decodes.
    IF ls_file-component = 'MIME_CONTENT' OR ls_file-component = 'W3MI_CONTENT'.
      IF lv_path NP '*.xml' AND lv_path NP '*.js' AND lv_path NP '*.css'
         AND lv_path NP '*.htm' AND lv_path NP '*.html' AND lv_path NP '*.svg'
         AND lv_path NP '*.json' AND lv_path NP '*.txt' AND lv_path NP '*.csv'.
        lv_error = 'Binary repository asset'.
      ENDIF.
    ENDIF.
    IF lv_error IS NOT INITIAL OR lv_error2 IS NOT INITIAL.
      PERFORM im_show_binary USING lv_old lv_new.
    ELSE.
      PERFORM im_format_note USING lv_old lv_new CHANGING lv_note.
      IF lv_note IS NOT INITIAL.
        WRITE / '줄바꿈 형식(CR/LF) 또는 UTF-8 BOM만 다릅니다.'.
      ENDIF.
      IF lv_path CP '*.xml' OR lv_path CP '*.svg'.
        CLEAR lv_generated.
        IF ls_file-check_mode <> 'RAW'. lv_generated = 'X'. ENDIF.
        PERFORM im_show_xml USING lv_old lv_new lv_generated.
        ULINE. WRITE / 'XML 원문 줄 비교 (원문 행 번호 기준)'.
      ENDIF.
      PERFORM im_split USING lv_text_old CHANGING lt_old lv_error.
      IF lv_error IS NOT INITIAL. WRITE / lv_error. RETURN. ENDIF.
      PERFORM im_split USING lv_text_new CHANGING lt_new lv_error.
      IF lv_error IS NOT INITIAL. WRITE / lv_error. RETURN. ENDIF.
      PERFORM im_diff_lines USING lt_old lt_new CHANGING lt_diff lv_note.
      PERFORM im_show_text USING lt_diff lv_note.
      IF lt_diff IS INITIAL.
        PERFORM im_show_binary USING lv_old lv_new.
      ENDIF.
    ENDIF.
  ENDIF.
  ULINE.
  WRITE / 'Related SAP reader diagnostics:'.
  LOOP AT gt_logs INTO ls_log WHERE object = ps_result-object
                                AND obj_name = ps_result-obj_name.
    WRITE: / ls_log-stage, ls_log-status, ls_log-component, ls_log-detail.
  ENDLOOP.
ENDFORM.


FORM im_summary CHANGING ct_lines TYPE ty_lines.
  TYPES: BEGIN OF ty_count,
           dimension TYPE i, status TYPE c LENGTH 26, count TYPE i,
         END OF ty_count.
  DATA: lt_counts TYPE SORTED TABLE OF ty_count
          WITH UNIQUE KEY dimension status,
        ls_count TYPE ty_count, ls_result TYPE im_result,
        lv_dim TYPE i, lv_field TYPE c LENGTH 30, lv_total TYPE i,
        lv_num TYPE c LENGTH 12, lv_label TYPE string,
        lv_line TYPE string, lv_piece TYPE string, lv_size TYPE i.
  FIELD-SYMBOLS: <lv_status> TYPE ANY, <ls_count> TYPE ty_count.
  REFRESH ct_lines.
  DESCRIBE TABLE im_results LINES lv_total.
  WRITE lv_total TO lv_num NO-GROUPING. CONDENSE lv_num.
  CONCATENATE '전체 결과:' lv_num
    '파일 / 집계는 ALV 필터 적용 전 전체 결과 기준' INTO lv_line SEPARATED BY space.
  APPEND lv_line TO ct_lines.
  LOOP AT im_results INTO ls_result.
    DO 6 TIMES.
      lv_dim = sy-index.
      CASE lv_dim.
        WHEN 1. lv_field = 'COMPARISON'.
        WHEN 2. lv_field = 'ZIP_CHANGE'.
        WHEN 3. lv_field = 'SAP_CHANGE'.
        WHEN 4. lv_field = 'READ_STATE'.
        WHEN 5. lv_field = 'VERSION_STATE'.
        WHEN 6. lv_field = 'VALIDATION'.
      ENDCASE.
      ASSIGN COMPONENT lv_field OF STRUCTURE ls_result TO <lv_status>.
      IF sy-subrc <> 0. CONTINUE. ENDIF.
      CLEAR ls_count. ls_count-dimension = lv_dim.
      ls_count-status = <lv_status>.
      IF ls_count-status IS INITIAL. ls_count-status = 'N/A'. ENDIF.
      READ TABLE lt_counts ASSIGNING <ls_count>
        WITH TABLE KEY dimension = lv_dim status = ls_count-status.
      IF sy-subrc = 0.
        ADD 1 TO <ls_count>-count.
      ELSE.
        ls_count-count = 1. INSERT ls_count INTO TABLE lt_counts.
      ENDIF.
    ENDDO.
  ENDLOOP.
  DO 6 TIMES.
    lv_dim = sy-index.
    CASE lv_dim.
      WHEN 1. lv_label = '추출본/SAP 대비:'.
      WHEN 2. lv_label = '추출본/원본 대비:'.
      WHEN 3. lv_label = 'SAP/원본 대비:'.
      WHEN 4. lv_label = 'SAP 조회 결과:'.
      WHEN 5. lv_label = '활성 버전 확인 결과:'.
      WHEN 6. lv_label = '문법형식 검증:'.
    ENDCASE.
    lv_line = lv_label.
    LOOP AT lt_counts INTO ls_count WHERE dimension = lv_dim.
      WRITE ls_count-count TO lv_num NO-GROUPING. CONDENSE lv_num.
      lv_piece = ls_count-status.
      PERFORM im_status_text USING ls_count-status CHANGING lv_piece.
      CONCATENATE lv_piece ': ' lv_num '건' INTO lv_piece.
      lv_size = strlen( lv_line ) + strlen( lv_piece ) + 3.
      IF lv_size > 180.
        APPEND lv_line TO ct_lines. lv_line = lv_label.
      ENDIF.
      IF lv_line = lv_label.
        CONCATENATE lv_line lv_piece INTO lv_line SEPARATED BY space.
      ELSE.
        CONCATENATE lv_line lv_piece INTO lv_line SEPARATED BY ' / '.
      ENDIF.
    ENDLOOP.
    APPEND lv_line TO ct_lines.
  ENDDO.
ENDFORM.

FORM im_main_status USING pt_excluding TYPE slis_t_extab.
  im_screen_mode = 'M'.
* Keep SAP's fullscreen ALV commands, including Back/Exit/Cancel.
  SET PF-STATUS 'STANDARD_FULLSCREEN' OF PROGRAM 'SAPLSLVC_FULLSCREEN'
    EXCLUDING pt_excluding.
  PERFORM im_header_display USING 'M'.
  PERFORM wa_top_show.
ENDFORM.

FORM im_detail_status USING pt_excluding TYPE slis_t_extab.
  im_screen_mode = 'D'.
  SET PF-STATUS 'STANDARD_FULLSCREEN' OF PROGRAM 'SAPLSLVC_FULLSCREEN'
    EXCLUDING pt_excluding.
  PERFORM im_header_display USING 'D'.
  PERFORM wa_top_show.
ENDFORM.













FORM im_print_value USING pv_label TYPE csequence pv_text TYPE string
                    CHANGING cv_rows TYPE i.
* Show boundaries and control characters; preserve meaningful spaces.
  DATA: lv_text TYPE string, lv_chunk TYPE c LENGTH 200,
        lv_take TYPE i, lv_len TYPE i, lv_label TYPE string.
  lv_text = pv_text. lv_label = pv_label.
  REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>horizontal_tab
    IN lv_text WITH '[TAB]'.
  REPLACE ALL OCCURRENCES OF im_cr IN lv_text WITH '[CR]'.
  REPLACE ALL OCCURRENCES OF gv_lf IN lv_text WITH '[LF]'.
  CONCATENATE '|' lv_text '|' INTO lv_text RESPECTING BLANKS.
  lv_len = strlen( lv_text ).
  WHILE lv_len > 0 AND cv_rows < 12000.
    lv_take = lv_len. IF lv_take > 200. lv_take = 200. ENDIF.
    lv_chunk = lv_text(lv_take).
    WRITE: / lv_label, 26 lv_chunk.
    ADD 1 TO cv_rows.
    lv_text = lv_text+lv_take. lv_len = strlen( lv_text ).
    lv_label = '   (계속)'.
  ENDWHILE.
ENDFORM.

FORM im_text_block USING pt_removed TYPE im_diffs pt_added TYPE im_diffs
                         pv_id TYPE i
                   CHANGING cv_rows TYPE i.
  DATA: lv_old TYPE i, lv_new TYPE i, lv_kind TYPE c LENGTH 12,
        ls_diff TYPE im_diff, lv_num TYPE c LENGTH 12, lv_label TYPE string.
  DESCRIBE TABLE pt_removed LINES lv_old.
  DESCRIBE TABLE pt_added LINES lv_new.
  IF lv_old = 0 AND lv_new = 0. RETURN. ENDIF.
  IF cv_rows >= 12000. RETURN. ENDIF.
  IF lv_old > 0 AND lv_new > 0.
    lv_kind = '변경'.
  ELSEIF lv_old > 0.
    lv_kind = '삭제'.
  ELSE.
    lv_kind = '추가'.
  ENDIF.
  ULINE.
  WRITE: / '블록', pv_id, lv_kind, '전', lv_old, '행 / 후', lv_new, '행'.
  ADD 2 TO cv_rows.
  LOOP AT pt_removed INTO ls_diff.
    WRITE ls_diff-old_line TO lv_num NO-GROUPING. CONDENSE lv_num.
    CONCATENATE '전(-) 행' lv_num INTO lv_label SEPARATED BY space.
    PERFORM im_print_value USING lv_label ls_diff-text CHANGING cv_rows.
    IF cv_rows >= 12000. EXIT. ENDIF.
  ENDLOOP.
  LOOP AT pt_added INTO ls_diff.
    WRITE ls_diff-new_line TO lv_num NO-GROUPING. CONDENSE lv_num.
    CONCATENATE '후(+) 행' lv_num INTO lv_label SEPARATED BY space.
    PERFORM im_print_value USING lv_label ls_diff-text CHANGING cv_rows.
    IF cv_rows >= 12000. EXIT. ENDIF.
  ENDLOOP.
ENDFORM.

FORM im_show_text USING pt_diff TYPE im_diffs pv_note TYPE string.
  DATA: lt_removed TYPE im_diffs, lt_added TYPE im_diffs,
        ls_diff TYPE im_diff, lv_del TYPE i, lv_add TYPE i,
        lv_blocks TYPE i, lv_rows TYPE i, lv_pending TYPE c.
  LOOP AT pt_diff INTO ls_diff.
    IF ls_diff-kind = '-'. ADD 1 TO lv_del. ENDIF.
    IF ls_diff-kind = '+'. ADD 1 TO lv_add. ENDIF.
  ENDLOOP.
  WRITE: / '텍스트 비교: 전쪽 삭제/교체 행', lv_del,
    '/ 후쪽 추가/교체 행', lv_add.
  WRITE / '같은 구간의 삭제+추가는 변경 블록입니다. 행끼리 임의로 1:1 대응하지 않습니다.'.
  WRITE / '전/후 행 번호는 각각 원문 기준입니다. | | 안은 값이며 [TAB]/[CR]/[LF]는 표시 기호입니다.'.
  IF pv_note IS NOT INITIAL. WRITE / pv_note. ENDIF.
  IF lv_del = 0 AND lv_add = 0.
    WRITE / '줄 내용은 같습니다. 아래 바이트 정보에서 개행/BOM/마지막 개행 차이를 확인하십시오.'.
    RETURN.
  ENDIF.
  LOOP AT pt_diff INTO ls_diff.
    IF ls_diff-kind = '-'.
      APPEND ls_diff TO lt_removed. lv_pending = 'X'.
    ELSEIF ls_diff-kind = '+'.
      APPEND ls_diff TO lt_added. lv_pending = 'X'.
    ELSEIF lv_pending = 'X'.
      ADD 1 TO lv_blocks.
      PERFORM im_text_block USING lt_removed lt_added lv_blocks CHANGING lv_rows.
      REFRESH: lt_removed, lt_added. CLEAR lv_pending.
    ENDIF.
    IF lv_rows >= 12000. EXIT. ENDIF.
  ENDLOOP.
  IF lv_pending = 'X' AND lv_rows < 12000.
    ADD 1 TO lv_blocks.
    PERFORM im_text_block USING lt_removed lt_added lv_blocks CHANGING lv_rows.
  ENDIF.
  IF lv_rows >= 12000.
    WRITE / 'DISPLAY_LIMIT: 상세 12000줄 표시 한도. 전체 내용 판정은 생략 없이 비교했습니다.'.
  ENDIF.
ENDFORM.

FORM im_xml_walk USING po_parent TYPE REF TO if_ixml_node
                       pv_path TYPE string pv_depth TYPE i pv_generated TYPE c
                 CHANGING ct_nodes TYPE im_xml_nodes cv_error TYPE string.
  TYPES: BEGIN OF ty_name_count,
           name TYPE string, count TYPE i,
         END OF ty_name_count.
  DATA: lo_node TYPE REF TO if_ixml_node, lo_scan TYPE REF TO if_ixml_node,
        lo_attr TYPE REF TO if_ixml_node,
        lo_map TYPE REF TO if_ixml_named_node_map,
        lt_names TYPE HASHED TABLE OF ty_name_count WITH UNIQUE KEY name,
        ls_name TYPE ty_name_count, ls_item TYPE im_xml_node,
        lv_type TYPE i, lv_scan_type TYPE i, lv_depth TYPE i,
        lv_total TYPE i, lv_index TYPE i, lv_attrs TYPE i,
        lv_name TYPE string, lv_num TYPE c LENGTH 12,
        lv_uri TYPE string, lv_blank TYPE string, lv_value TYPE string,
        lv_path TYPE string, lv_elements TYPE c.
  FIELD-SYMBOLS <ls_name> TYPE ty_name_count.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  IF pv_depth > 96.
    cv_error = 'XML 경로 분석 깊이 한도(96). 원문 줄 비교로 표시합니다.'. RETURN.
  ENDIF.
  lo_scan = po_parent->get_first_child( ).
  WHILE lo_scan IS NOT INITIAL.
    lv_scan_type = lo_scan->get_type( ).
    IF lv_scan_type = if_ixml_node=>co_node_element. lv_elements = 'X'. EXIT. ENDIF.
    lo_scan = lo_scan->get_next( ).
  ENDWHILE.
  lo_node = po_parent->get_first_child( ).
  WHILE lo_node IS NOT INITIAL.
    DESCRIBE TABLE ct_nodes LINES lv_total.
    IF lv_total >= 30000.
      cv_error = 'XML 경로 분석 항목 한도(30000). 원문 줄 비교로 표시합니다.'. RETURN.
    ENDIF.
    lv_type = lo_node->get_type( ).
    lv_name = lo_node->get_name( ).
    CLEAR lv_value.
* On SAP iXML, an element can expose all descendant text via GET_VALUE.
* Preserve its existence/path, but compare text only at its own text or
* CDATA node. Attributes are indexed separately below. This also avoids
* counting a leaf element and its text child as two value changes.
    IF lv_type <> if_ixml_node=>co_node_element.
      lv_value = lo_node->get_value( ).
    ENDIF.
    IF lv_type = if_ixml_node=>co_node_element.
      lv_uri = lo_node->get_namespace_uri( ).
      IF lv_uri IS NOT INITIAL.
        CONCATENATE '{' lv_uri '}' lv_name INTO lv_name.
      ENDIF.
    ELSE.
      WRITE lv_type TO lv_num NO-GROUPING. CONDENSE lv_num.
      CONCATENATE '#' lv_num ':' lv_name INTO lv_name.
    ENDIF.
* Only generated element-only asXML may ignore structural indentation.
    IF pv_generated = 'X' AND lv_elements = 'X' AND
       lv_type = if_ixml_node=>co_node_text.
      lv_blank = lv_value.
      REPLACE ALL OCCURRENCES OF gv_lf IN lv_blank WITH ''.
      REPLACE ALL OCCURRENCES OF im_cr IN lv_blank WITH ''.
      REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>horizontal_tab IN lv_blank WITH ''.
      CONDENSE lv_blank NO-GAPS.
      IF lv_blank IS INITIAL.
        lo_node = lo_node->get_next( ). CONTINUE.
      ENDIF.
    ENDIF.
    READ TABLE lt_names ASSIGNING <ls_name> WITH TABLE KEY name = lv_name.
    IF sy-subrc <> 0.
      ls_name-name = lv_name. ls_name-count = 0.
      INSERT ls_name INTO TABLE lt_names.
      READ TABLE lt_names ASSIGNING <ls_name> WITH TABLE KEY name = lv_name.
    ENDIF.
    ADD 1 TO <ls_name>-count.
    WRITE <ls_name>-count TO lv_num NO-GROUPING. CONDENSE lv_num.
    CONCATENATE pv_path '/' lv_name '[' lv_num ']' INTO lv_path.
    IF strlen( lv_path ) > 4096.
      cv_error = 'XML 항목 경로 길이 한도. 원문 줄 비교로 표시합니다.'. RETURN.
    ENDIF.
    CLEAR ls_item. ls_item-path = lv_path. ls_item-value = lv_value.
    INSERT ls_item INTO TABLE ct_nodes.
    IF sy-subrc <> 0.
      cv_error = 'XML 항목 경로가 중복되어 원문 줄 비교로 표시합니다.'. RETURN.
    ENDIF.
    lo_map = lo_node->get_attributes( ).
    IF lo_map IS NOT INITIAL.
      lv_attrs = lo_map->get_length( ). lv_index = 0.
      WHILE lv_index < lv_attrs.
        lo_attr = lo_map->get_item( index = lv_index ). ADD 1 TO lv_index.
        IF lo_attr IS INITIAL. CONTINUE. ENDIF.
        lv_name = lo_attr->get_name( ). lv_uri = lo_attr->get_namespace_uri( ).
        IF lv_uri IS NOT INITIAL.
          CONCATENATE '{' lv_uri '}' lv_name INTO lv_name.
        ENDIF.
        CLEAR ls_item.
        CONCATENATE lv_path '/@' lv_name INTO ls_item-path.
        ls_item-value = lo_attr->get_value( ). INSERT ls_item INTO TABLE ct_nodes.
        IF sy-subrc <> 0.
          cv_error = 'XML 속성 경로 중복. 원문 줄 비교로 표시합니다.'. RETURN.
        ENDIF.
        DESCRIBE TABLE ct_nodes LINES lv_total.
        IF lv_total >= 30000.
          cv_error = 'XML 항목 한도(30000). 원문 줄 비교로 표시합니다.'. RETURN.
        ENDIF.
      ENDWHILE.
    ENDIF.
    lv_depth = pv_depth + 1.
    PERFORM im_xml_walk USING lo_node lv_path lv_depth pv_generated
      CHANGING ct_nodes cv_error.
    IF cv_error IS NOT INITIAL. RETURN. ENDIF.
    lo_node = lo_node->get_next( ).
  ENDWHILE.
ENDFORM.

FORM im_xml_index USING pv_xml TYPE xstring pv_generated TYPE c
                  CHANGING ct_nodes TYPE im_xml_nodes cv_error TYPE string.
  DATA: lo_ixml TYPE REF TO if_ixml, lo_sf TYPE REF TO if_ixml_stream_factory,
        lo_in TYPE REF TO if_ixml_istream, lo_doc TYPE REF TO if_ixml_document,
        lo_parser TYPE REF TO if_ixml_parser, lo_node TYPE REF TO if_ixml_node,
        lv_rc TYPE i, lv_path TYPE string, lo_error TYPE REF TO cx_root.
  REFRESH ct_nodes. CLEAR cv_error.
  IF xstrlen( pv_xml ) > 2097152.
    cv_error = 'XML 항목 분석은 2 MiB까지 지원합니다. 원문 줄 비교를 확인하십시오.'. RETURN.
  ENDIF.
  TRY.
      PERFORM im_xml_document USING pv_xml CHANGING lo_doc cv_error.
      IF cv_error IS NOT INITIAL. RETURN. ENDIF.
      lo_node = lo_doc.
      PERFORM im_xml_walk USING lo_node lv_path 0 pv_generated
        CHANGING ct_nodes cv_error.
    CATCH cx_root INTO lo_error.
      cv_error = lo_error->get_text( ).
  ENDTRY.
  IF cv_error IS NOT INITIAL. REFRESH ct_nodes. ENDIF.
ENDFORM.

FORM im_show_xml USING pv_old TYPE xstring pv_new TYPE xstring pv_generated TYPE c.
  DATA: lt_old TYPE im_xml_nodes, lt_new TYPE im_xml_nodes,
        ls_old TYPE im_xml_node, ls_new TYPE im_xml_node,
        lv_error TYPE string, lv_rows TYPE i,
        lv_changed TYPE i, lv_added TYPE i, lv_deleted TYPE i.
  PERFORM im_xml_index USING pv_old pv_generated CHANGING lt_old lv_error.
  IF lv_error IS INITIAL.
    PERFORM im_xml_index USING pv_new pv_generated CHANGING lt_new lv_error.
  ENDIF.
  IF lv_error IS NOT INITIAL. WRITE / lv_error. RETURN. ENDIF.
  LOOP AT lt_old INTO ls_old.
    READ TABLE lt_new INTO ls_new WITH TABLE KEY path = ls_old-path.
    IF sy-subrc <> 0. ADD 1 TO lv_deleted.
    ELSEIF ls_old-value <> ls_new-value. ADD 1 TO lv_changed. ENDIF.
  ENDLOOP.
  LOOP AT lt_new INTO ls_new.
    READ TABLE lt_old TRANSPORTING NO FIELDS WITH TABLE KEY path = ls_new-path.
    IF sy-subrc <> 0. ADD 1 TO lv_added. ENDIF.
  ENDLOOP.
  WRITE: / 'XML 항목 비교: 값 변경', lv_changed, '/ 추가', lv_added, '/ 삭제', lv_deleted.
  WRITE / '경로의 [n]은 같은 이름의 형제 순번입니다. 반복 행 삽입/재정렬은 후속 경로에도 영향을 줍니다.'.
  WRITE / '#16은 텍스트, #32는 CDATA, @는 XML 속성입니다. 노드 건수는 업무 객체 건수가 아닙니다.'.
  WRITE / '업무 키 기반 행 대응이나 DDIC 적용 가능성 검사는 아닙니다. 원문 줄 비교도 함께 확인하십시오.'.
  IF lv_changed = 0 AND lv_added = 0 AND lv_deleted = 0.
    WRITE / '분석한 XML 경로/값은 같습니다. 표현·순서 등의 바이트 차이는 아래 원문 비교를 확인하십시오.'.
  ENDIF.
  LOOP AT lt_old INTO ls_old.
    READ TABLE lt_new INTO ls_new WITH TABLE KEY path = ls_old-path.
    IF sy-subrc <> 0.
      WRITE / '[삭제]'. ADD 1 TO lv_rows.
      PERFORM im_print_value USING '항목 경로' ls_old-path CHANGING lv_rows.
      PERFORM im_print_value USING '전 값' ls_old-value CHANGING lv_rows.
      WRITE / '후: 해당 항목 없음'. ADD 1 TO lv_rows.
    ELSEIF ls_old-value <> ls_new-value.
      WRITE / '[변경]'. ADD 1 TO lv_rows.
      PERFORM im_print_value USING '항목 경로' ls_old-path CHANGING lv_rows.
      PERFORM im_print_value USING '전 값' ls_old-value CHANGING lv_rows.
      PERFORM im_print_value USING '후 값' ls_new-value CHANGING lv_rows.
    ENDIF.
    IF lv_rows >= 12000. EXIT. ENDIF.
  ENDLOOP.
  IF lv_rows < 12000.
    LOOP AT lt_new INTO ls_new.
      READ TABLE lt_old TRANSPORTING NO FIELDS WITH TABLE KEY path = ls_new-path.
      IF sy-subrc <> 0.
        WRITE / '[추가]'. ADD 1 TO lv_rows.
        PERFORM im_print_value USING '항목 경로' ls_new-path CHANGING lv_rows.
        WRITE / '전: 해당 항목 없음'. ADD 1 TO lv_rows.
        PERFORM im_print_value USING '후 값' ls_new-value CHANGING lv_rows.
      ENDIF.
      IF lv_rows >= 12000. EXIT. ENDIF.
    ENDLOOP.
  ENDIF.
  IF lv_rows >= 12000. WRITE / 'DISPLAY_LIMIT: XML 상세 12000줄까지만 표시했습니다.'. ENDIF.
ENDFORM.

FORM im_show_binary USING pv_old TYPE xstring pv_new TYPE xstring.
  DATA: lv_old_len TYPE i, lv_new_len TYPE i, lv_max TYPE i,
        lv_offset TYPE i, lv_old_take TYPE i, lv_new_take TYPE i,
        lv_old TYPE xstring, lv_new TYPE xstring, lv_count TYPE i,
        lv_kind TYPE c LENGTH 12, lv_end TYPE i.
  lv_old_len = xstrlen( pv_old ). lv_new_len = xstrlen( pv_new ).
  lv_max = lv_old_len. IF lv_new_len > lv_max. lv_max = lv_new_len. ENDIF.
  WRITE: / '바이트 비교: 전', lv_old_len, 'bytes / 후', lv_new_len, 'bytes'.
  WRITE / '오프셋은 0부터 시작하며 16바이트 구간의 전후 HEX를 표시합니다.'.
  WRITE / '같은 위치 기준입니다. 중간 삽입으로 뒤쪽이 이동하면 여러 구간이 달라질 수 있습니다.'.
  WRITE / '이미지의 색상/구도나 압축 파일 내부의 의미 변화는 해석하지 않습니다.'.
  WHILE lv_offset < lv_max.
    CLEAR: lv_old, lv_new, lv_old_take, lv_new_take.
    IF lv_offset < lv_old_len.
      lv_old_take = lv_old_len - lv_offset.
      IF lv_old_take > 16. lv_old_take = 16. ENDIF.
      lv_old = pv_old+lv_offset(lv_old_take).
    ENDIF.
    IF lv_offset < lv_new_len.
      lv_new_take = lv_new_len - lv_offset.
      IF lv_new_take > 16. lv_new_take = 16. ENDIF.
      lv_new = pv_new+lv_offset(lv_new_take).
    ENDIF.
    IF lv_old <> lv_new.
      ADD 1 TO lv_count.
      IF lv_count > 256.
        WRITE / 'DISPLAY_LIMIT: 변경 구간은 처음 256개까지 표시. 전체 바이트 일치 판정에는 영향 없습니다.'.
        EXIT.
      ENDIF.
      lv_kind = '변경'.
      IF lv_old_take = 0. lv_kind = '추가'. ENDIF.
      IF lv_new_take = 0. lv_kind = '삭제'. ENDIF.
      lv_end = lv_offset + 15.
      IF lv_end >= lv_max. lv_end = lv_max - 1. ENDIF.
      WRITE: / lv_kind, '오프셋', lv_offset, '~', lv_end,
        / '전 HEX:', lv_old, / '후 HEX:', lv_new.
    ENDIF.
    ADD 16 TO lv_offset.
  ENDWHILE.
ENDFORM.

* --- Proven export 0.3.28 read/serialization helpers; memory sink only ---
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
  WRITE: / 'DEVHUB DIAG 0.4.5 - read-only validation build',
         / 'PASS: UTF-8 Korean round-trip, ZIP ADD/GET, CRC32 vector.',
         / 'PASS: Korean ZIP names and baselines survive SAVE/LOAD.',
         / 'PASS: direct INCLUDE reader fixture.',
         / 'PASS: function source selection fixtures.',
         / 'PASS: raw web bytes and safe filename fixtures.',
         / 'PASS: BSP Properties/Page Attributes XML value bytes.',
         / 'PASS: XML indentation, exact value bytes and corruption detection.',
         / 'PASS: message numbers, placeholders and Korean XML round-trip.',
         / 'Repository read only; comparison and validation report.'.
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
  IF p_bspm = 'X'. PERFORM scope_discover_bsp. RETURN. ENDIF.
  SELECT devclass FROM tdevc INTO TABLE gt_packages
    WHERE devclass = p_pack.
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
    PERFORM im_progress_pulse USING gs_package-devclass.
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
* BSP mode never dispatches package-wide serializers.
  IF p_bspm = 'X' AND
     ( gs_object-pgmid <> 'R3TR' OR
       ( gs_object-object <> 'WAPA' AND gs_object-object <> 'SMIM' ) OR
       ( gs_object-object = 'WAPA' AND gs_object-obj_name <> p_bsp ) ).
    gs_object-status = 'EXCLUDED'. gs_object-reason = 'Outside selected BSP scope'. RETURN.
  ENDIF.
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
      gs_object-reason = 'Cataloged; serializer not implemented in 0.3.28'.
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
  IF gs_object-object = 'WAPA'.
    PERFORM scope_bsp_root USING gs_object-devclass gs_object-obj_name
      CHANGING gv_root.
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
  PERFORM im_history_catalog USING 'MSAG' 'Messages.xml' gs_object-obj_name.
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
  DATA: lv_key TYPE string, lv_size TYPE i, lv_total TYPE i,
        ls_blob TYPE im_blob.
  IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  lv_key = pv_path. TRANSLATE lv_key TO UPPER CASE.
  INSERT lv_key INTO TABLE gt_paths.
  IF sy-subrc <> 0.
    CONCATENATE 'Duplicate live serializer path:' pv_path INTO gv_fatal
      SEPARATED BY space. RETURN.
  ENDIF.
  lv_size = xstrlen( pv_data ).
  IF lv_size > 16777216.
    gv_fatal = 'Current SAP payload exceeds 16 MiB/file or 512 MiB total'.
    RETURN.
  ENDIF.
  lv_total = gv_bytes + lv_size.
  IF lv_total > gv_maxbytes.
    gv_fatal = 'Current SAP payload exceeds 16 MiB/file or 512 MiB total'.
    RETURN.
  ENDIF.
  ls_blob-path = pv_path. ls_blob-data = pv_data.
  INSERT ls_blob INTO TABLE im_current.
  IF sy-subrc <> 0. gv_fatal = 'Duplicate current payload'. RETURN. ENDIF.
  gv_bytes = lv_total.
ENDFORM.

FORM add_file USING pv_relative TYPE csequence
                    pv_component TYPE csequence
                    pv_data TYPE xstring.
  DATA: ls_file TYPE ty_file, lv_data TYPE xstring,
        lv_error TYPE string.
  IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  PERFORM im_progress_pulse USING pv_relative.
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
  ls_file-active_state = 'U'.
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
  gv_payload_state = 'A'.
  PERFORM add_text USING lv_rel lv_component lv_text.
  CLEAR gv_payload_state.

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
    gv_payload_state = 'A'.
    PERFORM add_file USING lv_rel 'TEXTPOOL' lv_xml.
    CLEAR gv_payload_state.
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
  PERFORM im_attribute_link USING pv_prog lv_rel <ls_attr>.
  PERFORM im_history_program USING pv_prog <ls_attr>.
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
  PERFORM im_progress_pulse USING ps_function-funcname.
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
  PERFORM im_confirm_interface USING ps_function lv_prefix
    lt_import lt_export lt_change lt_tables lt_except
    lv_global lv_remote lv_update.
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
    gv_payload_state = 'A'.
    PERFORM add_file USING lv_rel 'DDIC_DEFINITION' lv_xml.
    CASE gs_object-object.
      WHEN 'TABL'.
        PERFORM im_history_capture USING lv_rel space ls_dd02v
          'AS4USER' 'AS4DATE' 'DDIC 활성 정의 헤더'.
      WHEN 'DTEL'.
        PERFORM im_history_capture USING lv_rel space ls_dd04v
          'AS4USER' 'AS4DATE' 'DDIC 활성 정의 헤더'.
      WHEN 'DOMA'.
        PERFORM im_history_capture USING lv_rel space ls_dd01v
          'AS4USER' 'AS4DATE' 'DDIC 활성 정의 헤더'.
      WHEN 'VIEW'.
        PERFORM im_history_capture USING lv_rel space ls_dd25v
          'AS4USER' 'AS4DATE' 'DDIC 활성 정의 헤더'.
      WHEN 'TTYP'.
        PERFORM im_history_capture USING lv_rel space ls_dd40v
          'AS4USER' 'AS4DATE' 'DDIC 활성 정의 헤더'.
      WHEN 'SHLP'.
        PERFORM im_history_capture USING lv_rel space ls_dd30v
          'AS4USER' 'AS4DATE' 'DDIC 활성 정의 헤더'.
    ENDCASE.
    CLEAR gv_payload_state.
    IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
    EXIT.
  ENDDO.
  CLEAR gv_file_language.
ENDFORM.

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
  DATA: lv_version TYPE ty_bsp_version, lo_error TYPE REF TO cx_root.
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
        lv_layout_ok TYPE c, lv_kind_text TYPE string, lv_error TYPE string, lv_rc TYPE sy-subrc,
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
  PERFORM im_progress_pulse USING ps_path-original_name.
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
        PERFORM im_history_capture USING lv_dir 'X' ls_attrs
          'CHANGEDBY' 'CHANGEDON' 'BSP 페이지 속성'.
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
              PERFORM wa_bsp_page_kind USING lv_type CHANGING lv_layout_ok lv_kind_text.
              IF lv_layout_ok = 'X'.
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
      PERFORM im_history_capture USING space 'X' ls_attrs
        'CHANGEDBY' 'CHANGEDON' 'BSP 애플리케이션 속성'.
      gv_payload_state = 'A'.
* Application class references are not read or logged by policy.
* MIME repository traversal checks ownership before reading any body.
      PERFORM im_history_capture USING 'MIMEs/' 'X' ls_attrs
        ' ' ' ' 'MIME 조회 API: 변경정보 미제공'.
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
  IF p_bspm = 'X'.
    PERFORM scope_url_check USING pv_url CHANGING gs_object-reason.
    IF gs_object-reason IS NOT INITIAL.
      CLEAR cv_read. gs_object-status = 'EXCLUDED'. RETURN.
    ENDIF.
  ENDIF.
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
            PERFORM im_history_catalog USING 'SMIM' lv_content_path lv_id.
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
  IF gv_bsp_flat = 'X'.
    cv_path = 'catalog/mime-metadata.xml'. RETURN.
  ENDIF.
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
  IF gv_bsp_flat = 'X'.
* One catalog for the app; each entry retains its actual DEVCLASS/LOIO.
    IF gt_mime_metadata IS NOT INITIAL.
      CLEAR: gs_object, gv_root, gv_file_language, gv_check_mode.
      gv_payload_state = 'U'.
      PERFORM mime_metadata_path USING gv_scope_package CHANGING lv_path.
      CALL TRANSFORMATION id SOURCE application = p_bsp
        entries = gt_mime_metadata RESULT XML lv_xml.
      PERFORM add_file USING lv_path 'MIME_METADATA' lv_xml.
    ENDIF.
  ELSE.
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
  ENDIF.
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
  PERFORM scope_url_check USING pv_url CHANGING cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
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
  PERFORM scope_bsp_root USING lv_package lv_app_name CHANGING cv_root.
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


FORM im_function_owner USING pv_function TYPE rs38l-name
                            pv_group TYPE tadir-obj_name
                      CHANGING cv_ok TYPE c.
  DATA lv_area TYPE rs38l-area.
  CLEAR cv_ok.
  SELECT SINGLE area FROM enlfdir INTO lv_area WHERE funcname = pv_function.
  IF sy-subrc = 0 AND lv_area = pv_group. cv_ok = 'X'. ENDIF.
ENDFORM.

FORM im_confirm_function_sources.
* Confirm an API representation only against the exact bytes of one
* independently read active INCLUDE in the SAME package/function group.
* Never promote metadata/interface XML or MIME content on this basis.
  TYPES: BEGIN OF ty_candidate,
           devclass TYPE tadir-devclass, group_name TYPE tadir-obj_name,
           function_name TYPE rs38l-name, path TYPE string, ambiguous TYPE c,
         END OF ty_candidate.
  DATA: lt_candidates TYPE HASHED TABLE OF ty_candidate
          WITH UNIQUE KEY devclass group_name function_name,
        ls_candidate TYPE ty_candidate,
        ls_file TYPE ty_file, ls_blob TYPE im_blob, ls_include TYPE im_blob,
        lv_function TYPE rs38l-name, lv_ok TYPE c,
        ls_proof TYPE im_version_proof, ls_link TYPE im_function_link,
        ls_include_file TYPE ty_file, lv_offset TYPE i.
  FIELD-SYMBOLS <ls_candidate> TYPE ty_candidate.
  PERFORM im_progress USING '함수 활성 소스 대조' 0 0 space.
  REFRESH: im_function_proofs, im_function_links.
  LOOP AT im_current_index INTO ls_file
    WHERE object = 'FUGR' AND active_state = 'A'.
    IF ls_file-path NP '*/Include/*.abap' AND
       ls_file-path NP '*/Inlcude/*.abap'. CONTINUE. ENDIF.
    READ TABLE im_current INTO ls_blob WITH TABLE KEY path = ls_file-path.
    IF sy-subrc <> 0. CONTINUE. ENDIF.
    PERFORM im_function_head USING ls_blob-data CHANGING lv_function.
    IF lv_function IS INITIAL. CONTINUE. ENDIF.
    CLEAR ls_candidate.
    ls_candidate-devclass = ls_file-devclass.
    ls_candidate-group_name = ls_file-obj_name.
    ls_candidate-function_name = lv_function.
    ls_candidate-path = ls_file-path.
    INSERT ls_candidate INTO TABLE lt_candidates.
    IF sy-subrc <> 0.
      READ TABLE lt_candidates ASSIGNING <ls_candidate> WITH TABLE KEY
        devclass = ls_candidate-devclass group_name = ls_candidate-group_name
        function_name = ls_candidate-function_name.
      IF sy-subrc = 0. <ls_candidate>-ambiguous = 'X'. ENDIF.
    ENDIF.
  ENDLOOP.
  LOOP AT im_current_index INTO ls_file WHERE component = 'FUNCTION_API_SOURCE'.
    PERFORM im_progress_pulse USING ls_file-path.
    CLEAR ls_proof. ls_proof-path = ls_file-path.
    ls_proof-state = 'VER_ATTEMPT_FAILED'.
    DO 1 TIMES.
      IF ls_file-object <> 'FUGR'.
        ls_proof-note = '대조 대상의 객체 유형이 함수그룹이 아니어서 활성 Include를 연결하지 못했습니다.'. EXIT.
      ENDIF.
      READ TABLE im_current INTO ls_blob WITH TABLE KEY path = ls_file-path.
      IF sy-subrc <> 0.
        ls_proof-state = 'VER_NOT_RUN'.
        ls_proof-note = '함수 API 소스 바이트가 없어 활성 Include 대조를 수행하지 않았습니다.'. EXIT.
      ENDIF.
      PERFORM im_function_head USING ls_blob-data CHANGING lv_function.
      IF lv_function IS INITIAL.
        ls_proof-note = '함수 API 소스에서 FUNCTION 선언의 이름을 식별하지 못해 활성 Include와 연결하지 못했습니다.'. EXIT.
      ENDIF.
      READ TABLE lt_candidates INTO ls_candidate WITH TABLE KEY
        devclass = ls_file-devclass group_name = ls_file-obj_name
        function_name = lv_function.
      IF sy-subrc <> 0.
        ls_proof-note = '현재 수집한 같은 개발클래스·함수그룹의 활성 Include에서 대응 소스를 찾지 못했습니다. 함수 비활성을 뜻하지 않습니다.'. EXIT.
      ENDIF.
      IF ls_candidate-ambiguous = 'X'.
        ls_proof-note = '같은 함수 이름의 활성 Include 후보가 여러 개여서 하나로 확정하지 못했습니다.'. EXIT.
      ENDIF.
      PERFORM im_function_owner USING lv_function ls_file-obj_name CHANGING lv_ok.
      IF lv_ok IS INITIAL.
        ls_proof-note = '함수의 ENLFDIR 소유 함수그룹이 현재 대상과 일치하는지 확인하지 못했습니다.'. EXIT.
      ENDIF.
      PERFORM im_history_function USING ls_file-path ls_candidate-path.
      READ TABLE im_current INTO ls_include WITH TABLE KEY path = ls_candidate-path.
      IF sy-subrc <> 0.
        ls_proof-note = '연결한 활성 Include의 비교용 바이트를 확보하지 못했습니다.'. EXIT.
      ENDIF.
      CLEAR ls_link.
      ls_link-api_path = ls_file-path. ls_link-include_path = ls_candidate-path.
      ls_link-function_name = lv_function. ls_link-group_name = ls_file-obj_name.
      READ TABLE im_current_index INTO ls_include_file WITH TABLE KEY path = ls_candidate-path.
      IF sy-subrc = 0. ls_link-include_name = ls_include_file-component. ENDIF.
      FIND '/Source code/' IN ls_file-path MATCH OFFSET lv_offset.
      IF sy-subrc = 0.
        ADD 1 TO lv_offset. ls_link-function_prefix = ls_file-path(lv_offset).
      ENDIF.
      INSERT ls_link INTO TABLE im_function_links.
      IF ls_blob-data <> ls_include-data.
        ls_proof-state = 'VER_SOURCE_DIFFERENT'.
        ls_proof-note = '함수 API와 READ REPORT STATE A로 읽은 Include의 바이트가 다릅니다. 상세의 활성 소스 대조에서 실제 차이를 확인하세요. 비활성 판정은 아닙니다.'. EXIT.
      ENDIF.
      ls_proof-state = 'VER_ACTIVE'.
      ls_proof-note = '같은 개발클래스·함수그룹에 속한 유일한 활성 Include와 함수 API 소스가 전체 바이트 단위로 일치합니다.'.
    ENDDO.
    INSERT ls_proof INTO TABLE im_function_proofs.
    ls_file-active_state = 'U'.
    IF ls_proof-state = 'VER_ACTIVE'. ls_file-active_state = 'A'. ENDIF.
    MODIFY TABLE im_current_index FROM ls_file.
  ENDLOOP.
ENDFORM.

FORM im_progress USING pv_stage TYPE csequence pv_done TYPE i
                       pv_total TYPE i pv_detail TYPE csequence.
  DATA lv_force TYPE c.
  IF im_progress_stage <> pv_stage. lv_force = 'X'. ENDIF.
  im_progress_stage = pv_stage.
  im_progress_done = pv_done. im_progress_total = pv_total.
  IF pv_total > 0 AND pv_done >= pv_total. lv_force = 'X'. ENDIF.
  PERFORM im_progress_emit USING pv_detail lv_force.
ENDFORM.

FORM im_progress_pulse USING pv_detail TYPE csequence.
  PERFORM im_progress_emit USING pv_detail space.
ENDFORM.

FORM im_progress_emit USING pv_detail TYPE csequence pv_force TYPE c.
* Phase percentage, not elapsed-time prediction. At most one GUI call
* per second except phase boundaries/completion. No COMMIT or writes.
  DATA: lv_percent TYPE i, lv_done TYPE c LENGTH 12,
        lv_total TYPE c LENGTH 12, lv_pct TYPE c LENGTH 4,
        lv_text TYPE string, lv_subrc TYPE sy-subrc, lv_tabix TYPE sy-tabix.
  IF sy-batch = 'X' OR im_progress_stage IS INITIAL. RETURN. ENDIF.
  lv_subrc = sy-subrc. lv_tabix = sy-tabix.
  GET TIME.
  IF pv_force IS INITIAL AND im_progress_sent = 'X' AND
     im_progress_date = sy-datum AND im_progress_time = sy-uzeit. RETURN. ENDIF.
  im_progress_date = sy-datum. im_progress_time = sy-uzeit.
  im_progress_sent = 'X'.
  IF im_progress_total > 0.
    lv_percent = im_progress_done * 100 / im_progress_total.
    IF lv_percent < 0. lv_percent = 0. ENDIF.
    IF lv_percent > 100. lv_percent = 100. ENDIF.
    IF im_progress_done < im_progress_total AND lv_percent >= 100.
      lv_percent = 99.
    ENDIF.
    WRITE im_progress_done TO lv_done NO-GROUPING. CONDENSE lv_done.
    WRITE im_progress_total TO lv_total NO-GROUPING. CONDENSE lv_total.
    WRITE lv_percent TO lv_pct NO-GROUPING. CONDENSE lv_pct.
    CONCATENATE im_progress_stage lv_pct '%' '(' lv_done '/' lv_total ')'
      pv_detail INTO lv_text SEPARATED BY space.
  ELSE.
    CONCATENATE im_progress_stage '처리 중' pv_detail INTO lv_text SEPARATED BY space.
  ENDIF.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING percentage = lv_percent text = lv_text
    EXCEPTIONS OTHERS = 1.
* Protect callers that inspect a just-completed read/loop result.
  sy-subrc = lv_subrc. sy-tabix = lv_tabix.
ENDFORM.

FORM im_progress_item USING pv_stage TYPE csequence pv_index TYPE i
                            pv_total TYPE i pv_detail TYPE csequence.
  DATA lv_done TYPE i.
  lv_done = pv_index - 1.
  IF lv_done < 0. lv_done = 0. ENDIF.
  PERFORM im_progress USING pv_stage lv_done pv_total pv_detail.
ENDFORM.

FORM im_attribute_link USING pv_program TYPE ty_name pv_relative TYPE string
                             pv_attributes TYPE any.
* Caller has completed two identical READ REPORT ... STATE 'A' reads.
* TRDIR itself is current metadata, not a separately versioned A record.
  DATA ls_proof TYPE im_version_proof.
  FIELD-SYMBOLS <lv_name> TYPE any.
  CONCATENATE gv_root pv_relative INTO ls_proof-path.
  ls_proof-state = 'VER_ATTEMPT_FAILED'.
  ls_proof-note = '현재 프로그램 속성의 이름을 읽은 활성 소스와 연결하지 못했습니다.'.
  ASSIGN COMPONENT 'NAME' OF STRUCTURE pv_attributes TO <lv_name>.
  IF sy-subrc = 0.
    IF <lv_name> = pv_program.
      ls_proof-state = 'VER_SOURCE_LINK'.
      ls_proof-note = 'TRDIR의 프로그램명과 STATE=A로 두 번 읽어 일치한 활성 소스의 이름이 같습니다. 속성 값은 현재 TRDIR 값이며 속성 전체에 별도 A 버전이 확인되었다는 뜻은 아닙니다.'.
    ENDIF.
  ENDIF.
  INSERT ls_proof INTO TABLE im_tab_proofs.
ENDFORM.

FORM im_prepare_interface_api.
* Resolve the actual installed API before calling it. In particular,
* never pass a NORMAL parameter or assume a later SAP interface.
  DATA: lt_meta TYPE STANDARD TABLE OF fupararef,
        ls_meta TYPE fupararef, lt_specs TYPE ty_lines,
        lv_spec TYPE string, lv_param TYPE fupararef-parameter,
        lv_direction TYPE fupararef-paramtype,
        lv_type TYPE fupararef-structure, lv_count TYPE i,
        lt_inputs TYPE SORTED TABLE OF fupararef-parameter
          WITH UNIQUE KEY table_line,
        lo_error TYPE REF TO cx_root.
  IF im_interface_prepared = 'X'. RETURN. ENDIF.
  im_interface_prepared = 'X'.
  TRY.
      SELECT * FROM fupararef INTO TABLE lt_meta
        WHERE funcname = 'FUNCTION_IMPORT_INTERFACE' AND r3state = 'A'.
      APPEND 'FUNCNAME|I|RS38L-NAME' TO lt_specs.
      APPEND 'INACTIVE_VERSION|I|CHAR1' TO lt_specs.
      APPEND 'GLOBAL_FLAG|E|RS38L-GLOBAL' TO lt_specs.
      APPEND 'REMOTE_CALL|E|RS38L-REMOTE' TO lt_specs.
      APPEND 'UPDATE_TASK|E|RS38L-UTASK' TO lt_specs.
      APPEND 'IMPORT_PARAMETER|T|RSIMP' TO lt_specs.
      APPEND 'EXPORT_PARAMETER|T|RSEXP' TO lt_specs.
      APPEND 'CHANGING_PARAMETER|T|RSCHA' TO lt_specs.
      APPEND 'TABLES_PARAMETER|T|RSTBL' TO lt_specs.
      APPEND 'EXCEPTION_LIST|T|RSEXC' TO lt_specs.
      LOOP AT lt_specs INTO lv_spec.
        SPLIT lv_spec AT '|' INTO lv_param lv_direction lv_type.
        CLEAR: lv_count, ls_meta.
        LOOP AT lt_meta INTO ls_meta
          WHERE parameter = lv_param AND paramtype = lv_direction.
          ADD 1 TO lv_count.
        ENDLOOP.
        IF lv_count <> 1 OR ls_meta-structure <> lv_type OR
           ls_meta-ref_class IS NOT INITIAL OR ls_meta-line_of IS NOT INITIAL OR
           ls_meta-table_of IS NOT INITIAL.
          CONCATENATE '설치된 활성 인터페이스 조회 API의 매개변수·유형 확인 실패:'
            lv_param INTO im_interface_error SEPARATED BY space. RETURN.
        ENDIF.
        IF lv_direction = 'I' OR lv_direction = 'T'.
          INSERT lv_param INTO TABLE lt_inputs.
        ENDIF.
      ENDLOOP.
      LOOP AT lt_meta INTO ls_meta.
        IF ls_meta-paramtype <> 'I' AND ls_meta-paramtype <> 'C' AND
           ls_meta-paramtype <> 'T'. CONTINUE. ENDIF.
        READ TABLE lt_inputs WITH TABLE KEY table_line = ls_meta-parameter
          TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0 AND ls_meta-optional IS INITIAL AND
           ls_meta-defaultval IS INITIAL.
          CONCATENATE '설치된 조회 API에 추가 필수 매개변수가 있습니다:'
            ls_meta-parameter INTO im_interface_error SEPARATED BY space. RETURN.
        ENDIF.
      ENDLOOP.
      im_interface_ready = 'X'.
    CATCH cx_root INTO lo_error.
      im_interface_error = lo_error->get_text( ).
  ENDTRY.
ENDFORM.

FORM im_interface_proof USING pv_prefix TYPE string pv_tab TYPE csequence
                              pv_current TYPE any pv_active TYPE any
                              pv_error TYPE string pv_flags TYPE c.
  DATA ls_proof TYPE im_version_proof.
  CONCATENATE gv_root pv_prefix pv_tab '.xml' INTO ls_proof-path.
  IF pv_error IS NOT INITIAL.
    ls_proof-state = 'VER_ATTEMPT_FAILED'.
    CONCATENATE '활성 인터페이스 대조를 완료하지 못했습니다:' pv_error
      INTO ls_proof-note SEPARATED BY space.
  ELSEIF pv_current <> pv_active.
    ls_proof-state = 'VER_DEFINITION_DIFF'.
    ls_proof-note = '현재 조회 값과 별도 활성 인터페이스 API 결과가 다릅니다. 조회 도중 변경 또는 API 표현 차이도 확인해야 하며, 객체 비활성 판정은 아닙니다.'.
  ELSEIF pv_flags = 'X'.
    ls_proof-state = 'VER_FLAGS_ACTIVE'.
    ls_proof-note = '활성 인터페이스 API와 GLOBAL/REMOTE/UPDATE 처리 속성이 일치합니다. 설명·작성자·날짜 등 나머지 속성은 현재 저장소 값이며 활성 버전 확인 범위가 아닙니다.'.
  ELSE.
    ls_proof-state = 'VER_INTERFACE_ACTIVE'.
    ls_proof-note = 'INACTIVE_VERSION=공백으로 조회한 활성 인터페이스와 ENTRIES의 전체 파라미터/예외 레코드가 일치합니다. DOCUMENTATION 설명문은 활성 버전 대조 범위가 아니며 XML 내용 비교에는 포함됩니다.'.
  ENDIF.
  INSERT ls_proof INTO TABLE im_tab_proofs.
ENDFORM.

FORM im_confirm_interface USING ps_function TYPE ty_function pv_prefix TYPE string
                                pv_import TYPE any pv_export TYPE any
                                pv_change TYPE any pv_tables TYPE any
                                pv_except TYPE any pv_global TYPE rs38l-global
                                pv_remote TYPE rs38l-remote pv_update TYPE rs38l-utask.
  DATA: lt_import TYPE STANDARD TABLE OF rsimp,
        lt_export TYPE STANDARD TABLE OF rsexp,
        lt_change TYPE STANDARD TABLE OF rscha,
        lt_tables TYPE STANDARD TABLE OF rstbl,
        lt_except TYPE STANDARD TABLE OF rsexc,
        BEGIN OF ls_active,
          global_flag TYPE rs38l-global,
          remote_call TYPE rs38l-remote,
          update_task TYPE rs38l-utask,
        END OF ls_active,
        ls_current LIKE ls_active,
        lv_api TYPE rs38l-name VALUE 'FUNCTION_IMPORT_INTERFACE',
        lv_error TYPE string, lv_inactive TYPE c,
        lv_rc TYPE sy-subrc, lv_num TYPE c LENGTH 12,
        lo_error TYPE REF TO cx_root.
  PERFORM im_progress_pulse USING ps_function-funcname.
  PERFORM im_prepare_interface_api.
  lv_error = im_interface_error.
  IF im_interface_ready = 'X'.
    TRY.
        CALL FUNCTION lv_api
          EXPORTING funcname = ps_function-funcname inactive_version = lv_inactive
          IMPORTING global_flag = ls_active-global_flag
            remote_call = ls_active-remote_call update_task = ls_active-update_task
          TABLES import_parameter = lt_import export_parameter = lt_export
            changing_parameter = lt_change tables_parameter = lt_tables
            exception_list = lt_except
          EXCEPTIONS error_message = 1 OTHERS = 2.
        lv_rc = sy-subrc.
        IF lv_rc <> 0.
          WRITE lv_rc TO lv_num NO-GROUPING. CONDENSE lv_num.
          CONCATENATE '활성 인터페이스 조회 실패, 반환코드' lv_num
            INTO lv_error SEPARATED BY space.
        ENDIF.
      CATCH cx_root INTO lo_error.
        lv_error = lo_error->get_text( ).
    ENDTRY.
  ELSEIF lv_error IS INITIAL.
    lv_error = '활성 인터페이스 조회 API를 확인하지 못했습니다.'.
  ENDIF.
  PERFORM im_interface_proof USING pv_prefix 'Import' pv_import lt_import lv_error space.
  PERFORM im_interface_proof USING pv_prefix 'Export' pv_export lt_export lv_error space.
  PERFORM im_interface_proof USING pv_prefix 'Changing' pv_change lt_change lv_error space.
  PERFORM im_interface_proof USING pv_prefix 'Tables' pv_tables lt_tables lv_error space.
  PERFORM im_interface_proof USING pv_prefix 'Exception' pv_except lt_except lv_error space.
  ls_current-global_flag = pv_global. ls_current-remote_call = pv_remote.
  ls_current-update_task = pv_update.
  PERFORM im_interface_proof USING pv_prefix 'Attributes' ls_current ls_active lv_error 'X'.
ENDFORM.

FORM im_xml_pair USING pt_old TYPE im_xml_nodes pt_new TYPE im_xml_nodes
                      pv_old_error TYPE string pv_new_error TYPE string
                      pv_old_ok TYPE c pv_new_ok TYPE c pv_same TYPE c
                CHANGING cv_state TYPE c cv_note TYPE csequence.
* Paths include namespace and sibling occurrence. Counts are XML paths,
* not a count of business parameters. No field/value is discarded.
  DATA: ls_old TYPE im_xml_node, ls_new TYPE im_xml_node,
        lv_add TYPE i, lv_del TYPE i, lv_change TYPE i,
        lv_a TYPE c LENGTH 12, lv_d TYPE c LENGTH 12, lv_c TYPE c LENGTH 12.
  CLEAR cv_note.
  cv_state = 'XML_NO_PAIR'.
  IF pv_old_ok IS INITIAL OR pv_new_ok IS INITIAL.
    cv_note = '한쪽 파일을 확보하지 못하여 XML 항목 비교를 수행하지 않았습니다.'. RETURN.
  ENDIF.
  IF pv_same = 'X'.
    cv_state = 'XML_BYTES_EQUAL'.
    cv_note = '전체 바이트 일치. 동일한 문서를 중복 파싱하지 않았습니다.'. RETURN.
  ENDIF.
  IF pv_old_error IS NOT INITIAL OR pv_new_error IS NOT INITIAL.
    cv_state = 'XML_REVIEW'.
    CONCATENATE pv_old_error pv_new_error INTO cv_note SEPARATED BY space. RETURN.
  ENDIF.
  LOOP AT pt_old INTO ls_old.
    READ TABLE pt_new INTO ls_new WITH TABLE KEY path = ls_old-path.
    IF sy-subrc <> 0. ADD 1 TO lv_del.
    ELSEIF ls_old-value <> ls_new-value. ADD 1 TO lv_change. ENDIF.
  ENDLOOP.
  LOOP AT pt_new INTO ls_new.
    READ TABLE pt_old WITH TABLE KEY path = ls_new-path TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0. ADD 1 TO lv_add. ENDIF.
  ENDLOOP.
  cv_state = 'XML_VALUES_EQUAL'.
  cv_note = 'XML 경로·값 일치. 바이트 불일치는 XML 표현 차이이며 실제 값은 같습니다.'.
  IF lv_add > 0 OR lv_del > 0 OR lv_change > 0.
    cv_state = 'XML_VALUES_DIFFERENT'.
    WRITE lv_add TO lv_a NO-GROUPING. CONDENSE lv_a.
    WRITE lv_del TO lv_d NO-GROUPING. CONDENSE lv_d.
    WRITE lv_change TO lv_c NO-GROUPING. CONDENSE lv_c.
    CONCATENATE 'XML 경로 기준 추가' lv_a '/ 삭제' lv_d '/ 값 변경' lv_c
      INTO cv_note SEPARATED BY space.
  ENDIF.
ENDFORM.

FORM im_xml_compare USING ps_file TYPE ty_file
                          pv_a TYPE xstring pv_b TYPE xstring pv_c TYPE xstring
                          pv_ao TYPE c pv_bo TYPE c pv_co TYPE c
                    CHANGING cs_result TYPE im_result.
  DATA: lt_a TYPE im_xml_nodes, lt_b TYPE im_xml_nodes, lt_c TYPE im_xml_nodes,
        lv_ae TYPE string, lv_be TYPE string, lv_ce TYPE string,
        lv_ab TYPE c, lv_ac TYPE c, lv_bc TYPE c,
        lv_generated TYPE c, lv_path TYPE string, lv_note TYPE string.
  lv_path = ps_file-path. TRANSLATE lv_path TO LOWER CASE.
  IF lv_path NP '*.xml'. RETURN. ENDIF.
  IF ps_file-check_mode = 'LF_UTF8'. lv_generated = 'X'. ENDIF.
  IF pv_ao = 'X' AND pv_bo = 'X' AND pv_a = pv_b. lv_ab = 'X'. ENDIF.
  IF pv_ao = 'X' AND pv_co = 'X' AND pv_a = pv_c. lv_ac = 'X'. ENDIF.
  IF pv_bo = 'X' AND pv_co = 'X' AND pv_b = pv_c. lv_bc = 'X'. ENDIF.
* Parse only byte-different, available pairs, at most once per distinct
* document. Tables are local to one file; no unbounded DOM cache.
  IF pv_ao = 'X' AND ( ( pv_bo = 'X' AND lv_ab IS INITIAL ) OR
                       ( pv_co = 'X' AND lv_ac IS INITIAL ) ).
    PERFORM im_xml_index USING pv_a lv_generated CHANGING lt_a lv_ae.
  ENDIF.
  IF pv_bo = 'X' AND ( ( pv_ao = 'X' AND lv_ab IS INITIAL ) OR
                       ( pv_co = 'X' AND lv_bc IS INITIAL ) ).
    IF lv_ab = 'X'. lt_b = lt_a. lv_be = lv_ae.
    ELSE. PERFORM im_xml_index USING pv_b lv_generated CHANGING lt_b lv_be. ENDIF.
  ENDIF.
  IF pv_co = 'X' AND ( ( pv_ao = 'X' AND lv_ac IS INITIAL ) OR
                       ( pv_bo = 'X' AND lv_bc IS INITIAL ) ).
    IF lv_ac = 'X'. lt_c = lt_a. lv_ce = lv_ae.
    ELSEIF lv_bc = 'X'. lt_c = lt_b. lv_ce = lv_be.
    ELSE. PERFORM im_xml_index USING pv_c lv_generated CHANGING lt_c lv_ce. ENDIF.
  ENDIF.
  PERFORM im_xml_pair USING lt_a lt_b lv_ae lv_be pv_ao pv_bo lv_ab
    CHANGING cs_result-xml_ab cs_result-xml_ab_note.
  PERFORM im_xml_pair USING lt_a lt_c lv_ae lv_ce pv_ao pv_co lv_ac
    CHANGING cs_result-xml_ac cs_result-xml_ac_note.
  PERFORM im_xml_pair USING lt_c lt_b lv_ce lv_be pv_co pv_bo lv_bc
    CHANGING cs_result-xml_bc cs_result-xml_note.
  IF cs_result-xml_ab = 'XML_VALUES_DIFFERENT'.
    PERFORM im_xml_scope_summary USING cs_result lt_a lt_b CHANGING cs_result-xml_scope_ab.
  ENDIF.
  IF cs_result-xml_ac = 'XML_VALUES_DIFFERENT'.
    PERFORM im_xml_scope_summary USING cs_result lt_a lt_c CHANGING cs_result-xml_scope_ac.
  ENDIF.
  IF cs_result-xml_bc = 'XML_VALUES_DIFFERENT'.
    PERFORM im_xml_scope_summary USING cs_result lt_c lt_b CHANGING cs_result-xml_scope_cb.
  ENDIF.
* The byte comparison, origin CRC and active-version proof are separate.
* Identical bytes must not become proof of activation or DDIC validity.
ENDFORM.

FORM im_pair_kind USING pv_base TYPE xstring pv_side TYPE xstring
                        pv_base_state TYPE c pv_side_state TYPE c
                  CHANGING cv_kind TYPE csequence.
* P = present and readable; N = confirmed absent; U = unknown.
* Absence and read failure are different. Both absent has no file to count.
  CLEAR cv_kind.
  IF pv_base_state = 'N' AND pv_side_state = 'P'. cv_kind = '신규'.
  ELSEIF pv_base_state = 'P' AND pv_side_state = 'N'. cv_kind = '누락'.
  ELSEIF pv_base_state = 'P' AND pv_side_state = 'P'.
    cv_kind = '변경없음'.
    IF pv_base <> pv_side. cv_kind = '수정'. ENDIF.
  ENDIF.
ENDFORM.

FORM im_pair_result USING pv_a TYPE xstring pv_b TYPE xstring pv_c TYPE xstring
                    CHANGING cs_result TYPE im_result.
  DATA: lv_path TYPE string, lv_package TYPE tadir-devclass,
        ls_absent TYPE im_absence_row, lv_note TYPE string.
  CLEAR: cs_result-pair_ab, cs_result-pair_ac, cs_result-pair_cb,
         cs_result-pair_note.
  cs_result-a_state = 'U'. cs_result-b_state = 'U'. cs_result-c_state = 'U'.
  IF cs_result-comparison = 'OUT_OF_SCOPE' OR
     cs_result-comparison = 'MAPPING_REJECTED'. RETURN. ENDIF.
  lv_path = cs_result-path.
  READ TABLE im_manifest_index WITH TABLE KEY path = lv_path TRANSPORTING NO FIELDS.
  IF sy-subrc <> 0. cs_result-a_state = 'N'.
  ELSEIF cs_result-a_ok = 'X'. cs_result-a_state = 'P'. ENDIF.
  READ TABLE im_entries_b WITH TABLE KEY path = lv_path TRANSPORTING NO FIELDS.
  IF sy-subrc <> 0. cs_result-b_state = 'N'.
  ELSEIF cs_result-b_ok = 'X'. cs_result-b_state = 'P'. ENDIF.
  IF cs_result-c_ok = 'X'.
    cs_result-c_state = 'P'.
  ELSEIF cs_result-object IS NOT INITIAL AND cs_result-obj_name IS NOT INITIAL.
* A missing serializer output does not prove a missing SAP component.
* Only absence of the owning R3TR object in TADIR confirms absence here.
    READ TABLE im_absence INTO ls_absent WITH TABLE KEY
      object = cs_result-object obj_name = cs_result-obj_name.
    IF sy-subrc <> 0.
      CLEAR ls_absent. ls_absent-object = cs_result-object.
      ls_absent-obj_name = cs_result-obj_name. ls_absent-state = 'U'.
      SELECT SINGLE devclass INTO lv_package FROM tadir
        WHERE pgmid = 'R3TR' AND object = cs_result-object
          AND obj_name = cs_result-obj_name.
      IF sy-subrc = 4. ls_absent-state = 'N'. ENDIF.
      INSERT ls_absent INTO TABLE im_absence.
    ENDIF.
    IF ls_absent-state = 'N'.
      cs_result-c_state = 'N'. cs_result-read_state = 'READ_MISSING'.
      cs_result-read_note = 'TADIR에서 소유 R3TR 객체가 없음을 확인했습니다. 파일 부재로 비교합니다.'.
      cs_result-version_state = 'VER_NOT_APPLICABLE'.
      cs_result-version_note = '소유 SAP 객체가 존재하지 않아 활성 버전 확인 대상이 없습니다.'.
    ENDIF.
  ENDIF.
  PERFORM im_pair_kind USING pv_a pv_b cs_result-a_state cs_result-b_state
    CHANGING cs_result-pair_ab.
  PERFORM im_pair_kind USING pv_a pv_c cs_result-a_state cs_result-c_state
    CHANGING cs_result-pair_ac.
* Direction is always current SAP -> extracted file, never the reverse.
  PERFORM im_pair_kind USING pv_c pv_b cs_result-c_state cs_result-b_state
    CHANGING cs_result-pair_cb.
  IF cs_result-a_state = 'U'.
    cs_result-pair_note = '원본 미확인: 원본 대비 비교 공란.'.
  ENDIF.
  IF cs_result-b_state = 'U'.
    CONCATENATE cs_result-pair_note '추출본 읽기 실패: 관련 비교 공란.'
      INTO cs_result-pair_note SEPARATED BY space.
  ENDIF.
  IF cs_result-c_state = 'U'.
    CONCATENATE cs_result-pair_note 'SAP 부재/내용 미확인: 관련 비교 공란.'
      INTO cs_result-pair_note SEPARATED BY space.
  ENDIF.
ENDFORM.

FORM im_byte_label USING pv_state TYPE c pv_size TYPE i
                   CHANGING cv_text TYPE csequence.
  DATA lv_size TYPE c LENGTH 16.
  cv_text = '읽기 불가'.
  IF pv_state = 'N'. cv_text = '없음'.
  ELSEIF pv_state = 'P'.
    WRITE pv_size TO lv_size NO-GROUPING. CONDENSE lv_size.
    cv_text = lv_size.
  ENDIF.
ENDFORM.

FORM im_header_free.
  PERFORM wa_top_free.
  IF im_head_grid_a IS NOT INITIAL.
    CALL METHOD im_head_grid_a->free EXCEPTIONS OTHERS = 1.
    FREE im_head_grid_a.
  ENDIF.
  IF im_head_grid_b IS NOT INITIAL.
    CALL METHOD im_head_grid_b->free EXCEPTIONS OTHERS = 1.
    FREE im_head_grid_b.
  ENDIF.
  FREE: im_head_cell_a, im_head_cell_b.
  IF im_head_split IS NOT INITIAL.
    CALL METHOD im_head_split->free EXCEPTIONS OTHERS = 1.
    FREE im_head_split.
  ENDIF.
  IF im_head_dock IS NOT INITIAL.
    CALL METHOD im_head_dock->free EXCEPTIONS OTHERS = 1.
    FREE im_head_dock.
  ENDIF.
  CLEAR im_head_failed.
ENDFORM.

FORM im_header_error.
  PERFORM im_header_free. im_head_failed = 'X'.
  MESSAGE '상단 요약 ALV 생성 실패. 하단 결과 목록은 계속 표시합니다.' TYPE 'I'.
ENDFORM.

FORM im_header_column USING pv_name TYPE csequence pv_title TYPE csequence
                            pv_width TYPE i pv_numeric TYPE c
                     CHANGING ct_fcat TYPE lvc_t_fcat.
  DATA: ls_field TYPE lvc_s_fcat, lv_position TYPE i.
  DESCRIBE TABLE ct_fcat LINES lv_position.
  ls_field-col_pos = lv_position + 1.
  ls_field-fieldname = pv_name. ls_field-coltext = pv_title.
  ls_field-scrtext_l = pv_title. ls_field-scrtext_m = pv_title.
  ls_field-scrtext_s = pv_title. ls_field-outputlen = pv_width.
  IF pv_numeric = 'X'.
    ls_field-datatype = 'INT4'. ls_field-inttype = 'I'. ls_field-intlen = 4.
    ls_field-just = 'R'. ls_field-no_sum = 'X'.
* A's zero counts remain visible; blank state slots in B suppress zeros.
    IF pv_name CP 'COUNT*'. ls_field-no_zero = 'X'. ENDIF.
  ELSE.
    ls_field-datatype = 'CHAR'. ls_field-inttype = 'C'.
  ENDIF.
  IF pv_name = 'LABEL'. ls_field-key = 'X'. ls_field-fix_column = 'X'. ENDIF.
  APPEND ls_field TO ct_fcat.
ENDFORM.

FORM im_header_main_data.
  TYPES: BEGIN OF ty_count,
           dimension TYPE i, status TYPE c LENGTH 26, count TYPE i,
         END OF ty_count.
  DATA: lt_counts TYPE SORTED TABLE OF ty_count WITH UNIQUE KEY dimension status,
        ls_count TYPE ty_count, ls_result TYPE im_result,
        ls_compare TYPE im_head_compare_row, ls_verify TYPE im_head_verify_row,
        lv_dim TYPE i, lv_kind TYPE c LENGTH 12, lv_slot TYPE i,
        lv_number TYPE c LENGTH 3, lv_field TYPE c LENGTH 30,
        lv_text TYPE string.
  FIELD-SYMBOLS: <ls_count> TYPE ty_count, <lv_cell> TYPE ANY.
  REFRESH: im_head_compare, im_head_verify. im_head_slots = 6.
  DO 3 TIMES.
    lv_dim = sy-index. CLEAR ls_compare.
    CASE lv_dim.
      WHEN 1. ls_compare-label = '추출본/원본 대비'.
      WHEN 2. ls_compare-label = 'SAP/원본 대비'.
      WHEN 3. ls_compare-label = '추출본/SAP 대비'.
    ENDCASE.
    LOOP AT im_results INTO ls_result.
      CASE lv_dim.
        WHEN 1. lv_kind = ls_result-pair_ab.
        WHEN 2. lv_kind = ls_result-pair_ac.
        WHEN 3. lv_kind = ls_result-pair_cb.
      ENDCASE.
      CASE lv_kind.
        WHEN '신규'. ADD 1 TO ls_compare-added.
        WHEN '누락'. ADD 1 TO ls_compare-missing.
        WHEN '수정'. ADD 1 TO ls_compare-modified.
        WHEN '변경없음'. ADD 1 TO ls_compare-same.
      ENDCASE.
    ENDLOOP.
    ls_compare-total = ls_compare-added + ls_compare-missing +
                       ls_compare-modified + ls_compare-same.
    APPEND ls_compare TO im_head_compare.
  ENDDO.
  LOOP AT im_all_results INTO ls_result.
    DO 2 TIMES.
      CLEAR ls_count. ls_count-dimension = sy-index.
      IF sy-index = 1. ls_count-status = ls_result-version_state.
      ELSE. ls_count-status = ls_result-validation. ENDIF.
      IF ls_count-status IS INITIAL. ls_count-status = 'N/A'. ENDIF.
      READ TABLE lt_counts ASSIGNING <ls_count> WITH TABLE KEY
        dimension = ls_count-dimension status = ls_count-status.
      IF sy-subrc = 0. ADD 1 TO <ls_count>-count.
      ELSE. ls_count-count = 1. INSERT ls_count INTO TABLE lt_counts. ENDIF.
    ENDDO.
  ENDLOOP.
  DO 2 TIMES.
    lv_dim = sy-index. CLEAR: ls_verify, lv_slot.
    IF lv_dim = 1. ls_verify-label = '활성 버전 확인 결과'.
    ELSE. ls_verify-label = '문법형식 검증'. ENDIF.
    LOOP AT lt_counts INTO ls_count WHERE dimension = lv_dim.
      ADD 1 TO lv_slot.
      WRITE lv_slot TO lv_number NO-GROUPING. CONDENSE lv_number.
      CONCATENATE 'STATUS' lv_number INTO lv_field.
      ASSIGN COMPONENT lv_field OF STRUCTURE ls_verify TO <lv_cell>.
      IF sy-subrc = 0.
        PERFORM im_status_text USING ls_count-status CHANGING lv_text.
        <lv_cell> = lv_text.
      ENDIF.
      CONCATENATE 'COUNT' lv_number INTO lv_field.
      ASSIGN COMPONENT lv_field OF STRUCTURE ls_verify TO <lv_cell>.
      IF sy-subrc = 0. <lv_cell> = ls_count-count. ENDIF.
    ENDLOOP.
* Six status/count pairs by default. If more states occur, add columns,
* never discard a status or wrap the two validation items into extra rows.
    IF lv_slot > im_head_slots. im_head_slots = lv_slot. ENDIF.
    APPEND ls_verify TO im_head_verify.
  ENDDO.
ENDFORM.

FORM im_header_detail_data.
  DATA: ls_row TYPE im_head_detail_row, lv_user TYPE string, lv_date TYPE string,
        ls_link TYPE im_function_link.
  PERFORM im_history_get USING im_view_result CHANGING lv_user lv_date.
  REFRESH: im_head_detail_a, im_head_detail_b.
  ls_row-label = '개발클래스'. ls_row-value = im_view_result-devclass.
  APPEND ls_row TO im_head_detail_a.
  ls_row-label = '파일경로'. ls_row-value = im_view_result-path.
  APPEND ls_row TO im_head_detail_a.
  ls_row-label = '객체명'. ls_row-value = im_view_result-obj_name.
  APPEND ls_row TO im_head_detail_a.
  ls_row-label = '추출본/원본 대비'. ls_row-value = im_view_result-pair_ab.
  APPEND ls_row TO im_head_detail_a.
  ls_row-label = 'SAP/원본 대비'. ls_row-value = im_view_result-pair_ac.
  APPEND ls_row TO im_head_detail_a.
  ls_row-label = '추출본/SAP 대비'. ls_row-value = im_view_result-pair_cb.
  APPEND ls_row TO im_head_detail_a.
  ls_row-label = '원본 bytes'. ls_row-value = im_view_bytes_a.
  APPEND ls_row TO im_head_detail_a.
  ls_row-label = 'SAP bytes'. ls_row-value = im_view_bytes_c.
  APPEND ls_row TO im_head_detail_a.
  PERFORM im_link_get USING im_view_result-path CHANGING ls_link.
  IF ls_link-api_path IS NOT INITIAL.
    ls_row-label = '함수명'. ls_row-value = ls_link-function_name.
    APPEND ls_row TO im_head_detail_a.
    ls_row-label = '소속 함수그룹'. ls_row-value = ls_link-group_name.
    APPEND ls_row TO im_head_detail_a.
    ls_row-label = '대응 Include'. ls_row-value = ls_link-include_name.
    APPEND ls_row TO im_head_detail_a.
    ls_row-label = '연결 파일 경로'. ls_row-value = ls_link-include_path.
    IF im_view_result-path = ls_link-include_path. ls_row-value = ls_link-api_path. ENDIF.
    APPEND ls_row TO im_head_detail_a.
    ls_row-label = '연결 근거'.
    ls_row-value = '같은 패키지·함수그룹의 유일한 FUNCTION 선언 및 ENLFDIR 소유 관계 확인'.
    APPEND ls_row TO im_head_detail_a.
  ENDIF.
  ls_row-label = 'SAP 검증 결과'.
  PERFORM im_status_text USING im_view_result-read_state CHANGING ls_row-value.
  APPEND ls_row TO im_head_detail_b.
  ls_row-label = '활성 버전 확인 결과'.
  PERFORM im_status_text USING im_view_result-version_state CHANGING ls_row-value.
  APPEND ls_row TO im_head_detail_b.
  ls_row-label = '문법형식 검증'.
  PERFORM im_status_text USING im_view_result-validation CHANGING ls_row-value.
  APPEND ls_row TO im_head_detail_b.
  ls_row-label = '추출본 bytes'. ls_row-value = im_view_bytes_b.
  APPEND ls_row TO im_head_detail_b.
  ls_row-label = '최종변경자'. ls_row-value = lv_user.
  APPEND ls_row TO im_head_detail_b.
  ls_row-label = '최종변경일'. ls_row-value = lv_date.
  APPEND ls_row TO im_head_detail_b.
ENDFORM.

FORM im_body_fit USING po_grid TYPE REF TO cl_gui_alv_grid.
* Resize the host as well as the grid. Widening FIELDCAT-OUTPUTLEN alone
* cannot remove space outside the fullscreen custom control.
* Edge alignment follows subsequent frontend window resizing; it does
* not reset user column widths, fixed columns, filters or scroll state.
  DATA: lo_parent TYPE REF TO cl_gui_container, lv_alignment TYPE i.
  IF po_grid IS INITIAL. RETURN. ENDIF.
  lo_parent = po_grid->parent.
  IF lo_parent IS INITIAL. RETURN. ENDIF.
  lv_alignment = cl_gui_control=>align_at_left + cl_gui_control=>align_at_right +
                 cl_gui_control=>align_at_top + cl_gui_control=>align_at_bottom.
  CALL METHOD lo_parent->set_alignment
    EXPORTING alignment = lv_alignment EXCEPTIONS OTHERS = 1.
  CALL METHOD po_grid->set_alignment
    EXPORTING alignment = lv_alignment EXCEPTIONS OTHERS = 1.
ENDFORM.

FORM im_header_geometry USING pv_mode TYPE c pv_a_rows TYPE i pv_b_rows TYPE i
                        CHANGING cv_height TYPE i cv_a_percent TYPE i.
* Pixel metric is explicit: no screen-height percentage and no ambiguous
* Dynpro units. Reserve title, column header and horizontal scrollbar.
* 22 px per line accommodates the compact SAP GUI 770 table style.
* The docking divider remains draggable for larger frontend font sizes.
  DATA: lv_a TYPE i, lv_b TYPE i.
  lv_a = pv_a_rows. lv_b = pv_b_rows.
  IF lv_a < 1. lv_a = 1. ENDIF.
  IF lv_b < 1. lv_b = 1. ENDIF.
  lv_a = ( lv_a + 3 ) * 22 + 4.
  lv_b = ( lv_b + 3 ) * 22 + 4.
  cv_a_percent = 50.
  IF pv_mode = 'M'.
    cv_height = lv_a + lv_b + 4.
    cv_a_percent = lv_a * 100 / cv_height.
  ELSE.
    cv_height = lv_a.
    IF lv_b > cv_height. cv_height = lv_b. ENDIF.
  ENDIF.
ENDFORM.

FORM im_header_display USING pv_mode TYPE c.
  DATA: lt_a TYPE lvc_t_fcat, lt_b TYPE lvc_t_fcat,
        ls_a TYPE lvc_s_layo, ls_b TYPE lvc_s_layo,
        lv_rows TYPE i, lv_cols TYPE i, lv_index TYPE i,
        lv_a_rows TYPE i, lv_b_rows TYPE i,
        lv_height TYPE i, lv_a_percent TYPE i,
        lv_number TYPE c LENGTH 3, lv_field TYPE c LENGTH 30,
        lv_title TYPE c LENGTH 40, lv_total TYPE c LENGTH 12.
  IF im_head_grid_a IS NOT INITIAL OR im_head_failed = 'X'. RETURN. ENDIF.
  IF pv_mode = 'M'.
    lv_rows = 2. lv_cols = 1.
    ls_a-grid_title = 'A. 파일 비교 / 합계: 판정 건수 (공란은 미확인 또는 양쪽 없음)'.
    WRITE im_total_results TO lv_total NO-GROUPING. CONDENSE lv_total.
    CONCATENATE 'B. SAP 검증 / 전체' lv_total '건 / 결과유형·변경 필터 적용 전'
      INTO ls_b-grid_title SEPARATED BY space.
    PERFORM im_header_column USING 'LABEL' '검증 항목' 24 space CHANGING lt_a.
    PERFORM im_header_column USING 'ADDED' '신규' 10 'X' CHANGING lt_a.
    PERFORM im_header_column USING 'MISSING' '누락' 10 'X' CHANGING lt_a.
    PERFORM im_header_column USING 'MODIFIED' '수정' 10 'X' CHANGING lt_a.
    PERFORM im_header_column USING 'SAME' '변경없음' 12 'X' CHANGING lt_a.
    PERFORM im_header_column USING 'TOTAL' '합계' 12 'X' CHANGING lt_a.
    PERFORM im_header_column USING 'LABEL' 'SAP 검증 결과' 24 space CHANGING lt_b.
    DO im_head_slots TIMES.
      lv_index = sy-index.
      WRITE lv_index TO lv_number NO-GROUPING. CONDENSE lv_number.
      CONCATENATE 'STATUS' lv_number INTO lv_field.
      PERFORM im_header_column USING lv_field '상태' 22 space CHANGING lt_b.
      CONCATENATE 'COUNT' lv_number INTO lv_field.
      PERFORM im_header_column USING lv_field '건수' 8 'X' CHANGING lt_b.
    ENDDO.
  ELSE.
    lv_rows = 1. lv_cols = 2.
    ls_a-grid_title = 'A. 비교/파일정보'. ls_b-grid_title = 'B. SAP 조회/검증 정보'.
    PERFORM im_header_column USING 'LABEL' '비교/파일정보' 24 space CHANGING lt_a.
    PERFORM im_header_column USING 'VALUE' '결과/값' 64 space CHANGING lt_a.
    PERFORM im_header_column USING 'LABEL' 'SAP 조회/검증 정보' 24 space CHANGING lt_b.
    PERFORM im_header_column USING 'VALUE' '결과/값' 28 space CHANGING lt_b.
  ENDIF.
  IF pv_mode = 'M'.
    DESCRIBE TABLE im_head_compare LINES lv_a_rows.
    DESCRIBE TABLE im_head_verify LINES lv_b_rows.
  ELSE.
    DESCRIBE TABLE im_head_detail_a LINES lv_a_rows.
    DESCRIBE TABLE im_head_detail_b LINES lv_b_rows.
  ENDIF.
  PERFORM im_header_geometry USING pv_mode lv_a_rows lv_b_rows
    CHANGING lv_height lv_a_percent.
  CREATE OBJECT im_head_dock
    EXPORTING side = cl_gui_docking_container=>dock_at_top
      extension = lv_height metric = cl_gui_control=>metric_pixel
    EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0. PERFORM im_header_error. RETURN. ENDIF.
  CREATE OBJECT im_head_split
    EXPORTING parent = im_head_dock rows = lv_rows columns = lv_cols
    EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0. PERFORM im_header_error. RETURN. ENDIF.
  CALL METHOD im_head_split->get_container
    EXPORTING row = 1 column = 1 RECEIVING container = im_head_cell_a.
  IF pv_mode = 'M'.
    CALL METHOD im_head_split->set_row_height
      EXPORTING id = 1 height = lv_a_percent EXCEPTIONS OTHERS = 1.
    CALL METHOD im_head_split->get_container
      EXPORTING row = 2 column = 1 RECEIVING container = im_head_cell_b.
  ELSE.
    CALL METHOD im_head_split->set_column_width
      EXPORTING id = 1 width = 65 EXCEPTIONS OTHERS = 1.
    CALL METHOD im_head_split->get_container
      EXPORTING row = 1 column = 2 RECEIVING container = im_head_cell_b.
  ENDIF.
  IF im_head_cell_a IS INITIAL OR im_head_cell_b IS INITIAL.
    PERFORM im_header_error. RETURN.
  ENDIF.
  CREATE OBJECT im_head_grid_a EXPORTING i_parent = im_head_cell_a EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0. PERFORM im_header_error. RETURN. ENDIF.
  CREATE OBJECT im_head_grid_b EXPORTING i_parent = im_head_cell_b EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0. PERFORM im_header_error. RETURN. ENDIF.
  ls_a-zebra = 'X'. ls_a-no_rowmark = 'X'. ls_a-no_toolbar = 'X'.
  ls_b-zebra = 'X'. ls_b-no_rowmark = 'X'. ls_b-no_toolbar = 'X'.
  IF pv_mode = 'M'.
    CALL METHOD im_head_grid_a->set_table_for_first_display
      EXPORTING is_layout = ls_a i_default = space
      CHANGING it_outtab = im_head_compare it_fieldcatalog = lt_a EXCEPTIONS OTHERS = 1.
    IF sy-subrc <> 0. PERFORM im_header_error. RETURN. ENDIF.
    CALL METHOD im_head_grid_b->set_table_for_first_display
      EXPORTING is_layout = ls_b i_default = space
      CHANGING it_outtab = im_head_verify it_fieldcatalog = lt_b EXCEPTIONS OTHERS = 1.
  ELSE.
    CALL METHOD im_head_grid_a->set_table_for_first_display
      EXPORTING is_layout = ls_a i_default = space
      CHANGING it_outtab = im_head_detail_a it_fieldcatalog = lt_a EXCEPTIONS OTHERS = 1.
    IF sy-subrc <> 0. PERFORM im_header_error. RETURN. ENDIF.
    CALL METHOD im_head_grid_b->set_table_for_first_display
      EXPORTING is_layout = ls_b i_default = space
      CHANGING it_outtab = im_head_detail_b it_fieldcatalog = lt_b EXCEPTIONS OTHERS = 1.
  ENDIF.
  IF sy-subrc <> 0. PERFORM im_header_error. RETURN. ENDIF.
ENDFORM.

FORM im_filter_match USING ps_row TYPE im_result CHANGING cv_match TYPE c.
  DATA: lv_path TYPE string, lv_mime TYPE c.
  CLEAR: cv_match, lv_mime.
* A display predicate only. Unknown/blank pairs are not changes.
* Do not require every pair to change: an edit in only ZIP or only SAP
* can leave another pair unchanged. Preserve those per-pair values.
  IF p_diff = 'X'.
    IF ps_row-pair_ab <> '신규' AND ps_row-pair_ab <> '누락' AND
       ps_row-pair_ab <> '수정' AND ps_row-pair_ac <> '신규' AND
       ps_row-pair_ac <> '누락' AND ps_row-pair_ac <> '수정' AND
       ps_row-pair_cb <> '신규' AND ps_row-pair_cb <> '누락' AND
       ps_row-pair_cb <> '수정'.
      RETURN.
    ENDIF.
  ENDIF.
  IF p_all = 'X'. cv_match = 'X'. RETURN. ENDIF.
  lv_path = ps_row-path. TRANSLATE lv_path TO LOWER CASE.
  PERFORM wa_is_web USING ps_row CHANGING lv_mime.
  IF p_src = 'X'.
    IF lv_path CP '*.abap' AND lv_mime IS INITIAL.
      cv_match = 'X'.
    ENDIF.
  ELSEIF p_xml = 'X'.
    IF lv_path CP '*.xml' AND lv_mime IS INITIAL. cv_match = 'X'. ENDIF.
  ELSEIF p_mime = 'X'.
    cv_match = lv_mime.
  ENDIF.
ENDFORM.

FORM im_filter_results.
* Run once after full comparison and syntax checks. Never filter the
* snapshot, manifest, program/include source set or activation evidence.
  DATA: ls_row TYPE im_result, lv_match TYPE c, lv_index TYPE i.
  PERFORM im_finalize_results.
  DESCRIBE TABLE im_results LINES im_total_results.
  im_filter_label = 'ABAP 소스'.
  IF p_all = 'X'. im_filter_label = '전체'. ENDIF.
  IF p_xml = 'X'. im_filter_label = 'XML'. ENDIF.
  IF p_mime = 'X'. im_filter_label = '웹자산'. ENDIF.
  LOOP AT im_results INTO ls_row.
    lv_index = sy-tabix.
    PERFORM im_filter_match USING ls_row CHANGING lv_match.
    IF lv_match IS INITIAL. DELETE im_results INDEX lv_index. ENDIF.
  ENDLOOP.
  IF im_results IS INITIAL.
    IF p_diff = 'X'.
      MESSAGE '선택한 유형에 신규/누락/수정 항목이 없습니다. 전체 확인은 체크를 해제하세요.' TYPE 'S'.
    ELSE.
      MESSAGE '선택한 결과 유형에 해당하는 항목이 없습니다. 결과 유형을 변경해 확인하세요.' TYPE 'S'.
    ENDIF.
  ENDIF.
ENDFORM.

FORM im_history_capture USING pv_relative TYPE csequence pv_prefix TYPE c
                              pv_attributes TYPE any
                              pv_user_field TYPE c pv_date_field TYPE c
                              pv_origin TYPE c.
* Capture fields from the same current SAP read used by diagnosis.
* No fallback to creator, generated-on, current user or ZIP file dates.
  DATA: ls_history TYPE im_history_row, lv_text TYPE string, lv_kind TYPE c.
  FIELD-SYMBOLS <lv_field> TYPE any.
  CONCATENATE gv_root pv_relative INTO ls_history-path.
  ls_history-is_prefix = pv_prefix. ls_history-origin = pv_origin.
  IF pv_user_field IS NOT INITIAL.
    ASSIGN COMPONENT pv_user_field OF STRUCTURE pv_attributes TO <lv_field>.
    IF sy-subrc = 0.
      DESCRIBE FIELD <lv_field> TYPE lv_kind.
      IF lv_kind = 'C' OR lv_kind = 'g'. ls_history-changed_by = <lv_field>. ENDIF.
    ENDIF.
  ENDIF.
  IF pv_date_field IS NOT INITIAL.
    UNASSIGN <lv_field>.
    ASSIGN COMPONENT pv_date_field OF STRUCTURE pv_attributes TO <lv_field>.
    IF sy-subrc = 0.
      DESCRIBE FIELD <lv_field> TYPE lv_kind.
      IF lv_kind = 'D' OR lv_kind = 'C' OR lv_kind = 'N'.
        lv_text = <lv_field>.
        IF strlen( lv_text ) = 8 AND lv_text CO '0123456789' AND lv_text <> '00000000'.
          ls_history-changed_on = lv_text.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
  DELETE TABLE im_history WITH TABLE KEY path = ls_history-path.
  INSERT ls_history INTO TABLE im_history.
ENDFORM.

FORM im_history_program USING pv_program TYPE ty_name pv_attributes TYPE any.
  DATA: lv_segment TYPE string, lv_relative TYPE string.
  PERFORM segment USING pv_program CHANGING lv_segment.
  IF gs_object-object = 'FUGR'.
    CONCATENATE 'Include/' lv_segment '.abap' INTO lv_relative.
  ELSE.
    CONCATENATE 'source/' lv_segment '.abap' INTO lv_relative.
  ENDIF.
  PERFORM im_history_capture USING lv_relative space pv_attributes
    'UNAM' 'UDAT' '해당 프로그램 TRDIR'.
  CONCATENATE 'attributes/' lv_segment '.xml' INTO lv_relative.
  PERFORM im_history_capture USING lv_relative space pv_attributes
    'UNAM' 'UDAT' '해당 프로그램 TRDIR'.
  CONCATENATE 'texts/' lv_segment '.xml' INTO lv_relative.
  PERFORM im_history_capture USING lv_relative space pv_attributes
    'UNAM' 'UDAT' '소유 프로그램 TRDIR'.
ENDFORM.

FORM im_history_function USING pv_function_path TYPE string pv_include_path TYPE string.
  DATA: ls_history TYPE im_history_row, lv_at TYPE i.
  READ TABLE im_history INTO ls_history WITH TABLE KEY path = pv_include_path.
  IF sy-subrc <> 0. RETURN. ENDIF.
  FIND FIRST OCCURRENCE OF '/Source code/' IN pv_function_path MATCH OFFSET lv_at.
  IF sy-subrc <> 0. RETURN. ENDIF.
  ADD 1 TO lv_at.
  ls_history-path = pv_function_path(lv_at).
  ls_history-is_prefix = 'X'.
  ls_history-origin = '함수별 Include TRDIR'.
  DELETE TABLE im_history WITH TABLE KEY path = ls_history-path.
  INSERT ls_history INTO TABLE im_history.
ENDFORM.

FORM im_history_catalog USING pv_kind TYPE c pv_relative TYPE csequence pv_key TYPE csequence.
* Called only after the authorized in-scope reader succeeded. Optional
* metadata cannot fail diagnosis. Dynamic types tolerate older releases.
  DATA: lv_table TYPE string, lv_where TYPE string, lv_key TYPE c LENGTH 120,
        lr_data TYPE REF TO data, lv_user_field TYPE c LENGTH 30,
        lv_date_field TYPE c LENGTH 30, lv_origin TYPE c LENGTH 50.
  FIELD-SYMBOLS <ls_data> TYPE any.
  lv_key = pv_key.
  CASE pv_kind.
    WHEN 'MSAG'.
      lv_table = 'T100A'. lv_where = 'ARBGB = LV_KEY'.
      lv_user_field = 'LASTUSER'. lv_date_field = 'LDATE'.
      lv_origin = '메시지 클래스 T100A'.
    WHEN 'SMIM'.
      lv_table = 'SMIMLOIO'. lv_where = 'LOIO_ID = LV_KEY'.
      lv_user_field = 'CHNG_USER'.
* No assumed timestamp field/conversion on SAP_BASIS 700. Do not use
* creation date/user as a substitute for missing change information.
      lv_origin = 'MIME LOIO 속성; 변경일 미조회'.
    WHEN OTHERS. RETURN.
  ENDCASE.
  TRY.
      CREATE DATA lr_data TYPE (lv_table).
      ASSIGN lr_data->* TO <ls_data>.
      SELECT SINGLE * FROM (lv_table) INTO <ls_data> WHERE (lv_where).
      IF sy-subrc = 0.
        PERFORM im_history_capture USING pv_relative space <ls_data>
          lv_user_field lv_date_field lv_origin.
      ENDIF.
    CATCH cx_root.
* Only optional display information; no invented values or error status.
  ENDTRY.
ENDFORM.

FORM im_history_get USING ps_result TYPE im_result
                    CHANGING cv_user TYPE string cv_date TYPE string.
  DATA: ls_history TYPE im_history_row, ls_best TYPE im_history_row,
        lv_size TYPE i, lv_best TYPE i, lv_path TYPE string, lv_len TYPE i.
  cv_user = '확인 불가'. cv_date = '확인 불가'.
  IF ps_result-c_state = 'N'.
    cv_user = 'SAP에 없음'. cv_date = 'SAP에 없음'. RETURN.
  ENDIF.
  IF ps_result-c_state <> 'P'. RETURN. ENDIF.
  lv_path = ps_result-path. lv_len = strlen( lv_path ).
  READ TABLE im_history INTO ls_best WITH TABLE KEY path = lv_path.
  IF sy-subrc <> 0.
    LOOP AT im_history INTO ls_history WHERE is_prefix = 'X'.
      lv_size = strlen( ls_history-path ).
      IF lv_size <= lv_best OR lv_size > lv_len. CONTINUE. ENDIF.
      IF lv_path(lv_size) = ls_history-path.
        ls_best = ls_history. lv_best = lv_size.
      ENDIF.
    ENDLOOP.
  ENDIF.
  IF ls_best-path IS INITIAL. RETURN. ENDIF.
  IF ls_best-changed_by IS NOT INITIAL. cv_user = ls_best-changed_by. ENDIF.
  IF ls_best-changed_on IS NOT INITIAL. cv_date = ls_best-changed_on. ENDIF.
* Make page/include/definition scope explicit, not an audit-history claim.
  IF ls_best-origin IS NOT INITIAL.
    CONCATENATE cv_user '(' ls_best-origin ')' INTO cv_user SEPARATED BY space.
  ENDIF.
ENDFORM.

FORM im_enrich_result CHANGING cs_row TYPE im_result.

    PERFORM im_file_name USING cs_row-path CHANGING cs_row-filename.
    cs_row-comparison_text = cs_row-pair_cb.
    cs_row-zip_change_text = cs_row-pair_ab.
    cs_row-sap_change_text = cs_row-pair_ac.
    PERFORM im_status_text USING cs_row-read_state CHANGING cs_row-read_text.
    PERFORM im_status_text USING cs_row-version_state CHANGING cs_row-version_text.
    PERFORM im_status_text USING cs_row-validation CHANGING cs_row-validation_text.
    PERFORM im_status_text USING cs_row-ab_format CHANGING cs_row-format_text.
    IF cs_row-xml_bc IS NOT INITIAL.
      PERFORM im_status_text USING cs_row-xml_ab CHANGING cs_row-xml_ab_text.
      PERFORM im_status_text USING cs_row-xml_ac CHANGING cs_row-xml_ac_text.
      PERFORM im_status_text USING cs_row-xml_bc CHANGING cs_row-xml_bc_text.
    ENDIF.
    cs_row-validation_note = cs_row-message.
    IF cs_row-xml_scope_cb IS NOT INITIAL.
      CONCATENATE '추출본/SAP XML:' cs_row-xml_scope_cb INTO cs_row-message SEPARATED BY space.
    ELSEIF cs_row-xml_scope_ac IS NOT INITIAL.
      CONCATENATE 'SAP/원본 XML:' cs_row-xml_scope_ac INTO cs_row-message SEPARATED BY space.
    ELSEIF cs_row-xml_scope_ab IS NOT INITIAL.
      CONCATENATE '추출본/원본 XML:' cs_row-xml_scope_ab INTO cs_row-message SEPARATED BY space.
    ENDIF.
    IF cs_row-pair_note IS NOT INITIAL.
      CONCATENATE cs_row-pair_note cs_row-message
        INTO cs_row-message SEPARATED BY space.
    ENDIF.
    REPLACE ALL OCCURRENCES OF 'BASELINE' IN cs_row-message WITH '원본'.
    REPLACE ALL OCCURRENCES OF 'ZIP' IN cs_row-message WITH '추출본'.

ENDFORM.

FORM im_finalize_results.
* Preserve all rows before result-type/changed-only filters and ALV filters.
  FIELD-SYMBOLS <ls_row> TYPE im_result.
  LOOP AT im_results ASSIGNING <ls_row>.
    PERFORM im_enrich_result CHANGING <ls_row>.
  ENDLOOP.
  im_all_results = im_results.
ENDFORM.

FORM im_link_get USING pv_path TYPE csequence CHANGING cs_link TYPE im_function_link.
  DATA: lv_path TYPE string, ls_link TYPE im_function_link, lv_len TYPE i.
  CLEAR cs_link. lv_path = pv_path.
  READ TABLE im_function_links INTO cs_link WITH TABLE KEY api_path = lv_path.
  IF sy-subrc = 0. RETURN. ENDIF.
  LOOP AT im_function_links INTO ls_link.
    IF ls_link-include_path = lv_path. cs_link = ls_link. RETURN. ENDIF.
    lv_len = strlen( ls_link-function_prefix ).
    IF lv_len > 0 AND strlen( lv_path ) > lv_len.
      IF lv_path(lv_len) = ls_link-function_prefix.
        cs_link = ls_link. RETURN.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.

FORM im_xml_scope USING ps_result TYPE im_result pv_path TYPE string
                 CHANGING cv_scope TYPE csequence.
* Only classify the exporter schema we know. Never classify from values.
  cv_scope = 'XML'.
  IF ps_result-object <> 'FUGR' OR ps_result-component <> 'FUNCTION_TAB' OR
     ps_result-path NP '*/Function Module/*/Attributes.xml'. RETURN. ENDIF.
  IF pv_path CS '/ENTRIES[1]/MAIN_PROGRAM_ATTRIBUTES[1]'.
    cv_scope = '공통 프로그램'.
  ELSEIF pv_path CS '/ENTRIES[1]/GROUP_TEXT[1]' OR
         pv_path CS '/ENTRIES[1]/REPOSITORY_ENTRY[1]'.
    cv_scope = '공통 함수그룹'.
  ELSEIF pv_path CS '/ENTRIES[1]/'.
    cv_scope = '함수 자체'.
  ELSE.
    cv_scope = 'XML 기타'.
  ENDIF.
ENDFORM.

FORM im_xml_scope_summary USING ps_result TYPE im_result
                               pt_old TYPE im_xml_nodes pt_new TYPE im_xml_nodes
                         CHANGING cv_summary TYPE csequence.
  DATA: lt_paths TYPE im_paths, lv_path TYPE string,
        ls_old TYPE im_xml_node, ls_new TYPE im_xml_node,
        lv_old TYPE c, lv_new TYPE c, lv_scope TYPE c LENGTH 24,
        lv_own TYPE i, lv_prog TYPE i, lv_group TYPE i, lv_other TYPE i,
        lv_a TYPE c LENGTH 12, lv_b TYPE c LENGTH 12,
        lv_c TYPE c LENGTH 12, lv_d TYPE c LENGTH 12.
  CLEAR cv_summary.
  IF ps_result-object <> 'FUGR' OR ps_result-component <> 'FUNCTION_TAB' OR
     ps_result-path NP '*/Function Module/*/Attributes.xml'. RETURN. ENDIF.
  LOOP AT pt_old INTO ls_old. INSERT ls_old-path INTO TABLE lt_paths. ENDLOOP.
  LOOP AT pt_new INTO ls_new. INSERT ls_new-path INTO TABLE lt_paths. ENDLOOP.
  LOOP AT lt_paths INTO lv_path.
    CLEAR: ls_old, ls_new, lv_old, lv_new.
    READ TABLE pt_old INTO ls_old WITH TABLE KEY path = lv_path.
    IF sy-subrc = 0. lv_old = 'X'. ENDIF.
    READ TABLE pt_new INTO ls_new WITH TABLE KEY path = lv_path.
    IF sy-subrc = 0. lv_new = 'X'. ENDIF.
    IF lv_old = lv_new AND ls_old-value = ls_new-value. CONTINUE. ENDIF.
    PERFORM im_xml_scope USING ps_result lv_path CHANGING lv_scope.
    CASE lv_scope.
      WHEN '함수 자체'. ADD 1 TO lv_own.
      WHEN '공통 프로그램'. ADD 1 TO lv_prog.
      WHEN '공통 함수그룹'. ADD 1 TO lv_group.
      WHEN OTHERS. ADD 1 TO lv_other.
    ENDCASE.
  ENDLOOP.
  WRITE lv_own TO lv_a NO-GROUPING. CONDENSE lv_a.
  WRITE lv_prog TO lv_b NO-GROUPING. CONDENSE lv_b.
  WRITE lv_group TO lv_c NO-GROUPING. CONDENSE lv_c.
  WRITE lv_other TO lv_d NO-GROUPING. CONDENSE lv_d.
  CONCATENATE '함수 자체' lv_a '/ 공통 프로그램' lv_b '/ 공통 함수그룹' lv_c
    '/ 기타' lv_d '(변경 XML 경로 수; 실제 필드는 상세의 구분·경로 참조)'
    INTO cv_summary SEPARATED BY space.
ENDFORM.

FORM im_proof_emit USING pv_kind TYPE csequence pv_api_line TYPE i pv_api TYPE string
                         pv_inc_line TYPE i pv_inc TYPE string
                   CHANGING ct_rows TYPE im_proof_rows.
  DATA: ls_row TYPE im_proof_row, lv_a TYPE string, lv_b TYPE string,
        lv_take TYPE i, lv_part TYPE i, lv_count TYPE i.
  PERFORM im_view_value USING pv_api CHANGING lv_a.
  PERFORM im_view_value USING pv_inc CHANGING lv_b.
  DO.
    DESCRIBE TABLE ct_rows LINES lv_count.
    IF lv_count >= 12000. EXIT. ENDIF.
    CLEAR ls_row. ADD 1 TO lv_part.
    ls_row-seq = lv_count + 1. ls_row-kind = pv_kind. ls_row-part = lv_part.
    ls_row-api_line = pv_api_line. ls_row-include_line = pv_inc_line.
    lv_take = strlen( lv_a ). IF lv_take > 128. lv_take = 128. ENDIF.
    IF lv_take > 0. ls_row-api_text = lv_a(lv_take). lv_a = lv_a+lv_take. ENDIF.
    lv_take = strlen( lv_b ). IF lv_take > 128. lv_take = 128. ENDIF.
    IF lv_take > 0. ls_row-include_text = lv_b(lv_take). lv_b = lv_b+lv_take. ENDIF.
    CASE pv_kind.
      WHEN '수정'. ls_row-color = 'C310'.
      WHEN '신규'. ls_row-color = 'C510'.
      WHEN '누락'. ls_row-color = 'C610'.
      WHEN '안내'. ls_row-color = 'C410'.
    ENDCASE.
    APPEND ls_row TO ct_rows.
    IF lv_a IS INITIAL AND lv_b IS INITIAL. EXIT. ENDIF.
  ENDDO.
ENDFORM.

FORM im_proof_build USING ps_link TYPE im_function_link CHANGING ct_rows TYPE im_proof_rows.
* This is a separate API-to-active-Include comparison, not a ZIP/SAP pair.
  DATA: ls_api TYPE im_blob, ls_inc TYPE im_blob, lt_a TYPE ty_lines, lt_b TYPE ty_lines,
        lv_a TYPE string, lv_b TYPE string, lv_error TYPE string, lv_note TYPE string,
        lt_map TYPE im_side_rows, ls_map TYPE im_side_row,
        lv_kind TYPE c LENGTH 24, lv_ha TYPE c, lv_line TYPE i,
        lv_count TYPE i, lv_diff TYPE c, lv_limited TYPE c,
        lv_api_bytes TYPE c LENGTH 12, lv_inc_bytes TYPE c LENGTH 12,
        lv_size TYPE i, lv_pos TYPE i, lv_take TYPE i,
        lv_ax TYPE xstring, lv_bx TYPE xstring, lv_hex TYPE c LENGTH 32.
  REFRESH ct_rows.
  READ TABLE im_current INTO ls_api WITH TABLE KEY path = ps_link-api_path.
  IF sy-subrc <> 0. RETURN. ENDIF.
  READ TABLE im_current INTO ls_inc WITH TABLE KEY path = ps_link-include_path.
  IF sy-subrc <> 0. RETURN. ENDIF.
  lv_a = '현재 SAP 함수 API 소스'. lv_b = '현재 SAP 활성 Include (READ REPORT STATE A)'.
  PERFORM im_proof_emit USING '안내' 0 lv_a 0 lv_b CHANGING ct_rows.
  PERFORM im_proof_emit USING '안내' 0 ps_link-api_path 0 ps_link-include_path CHANGING ct_rows.
  lv_size = xstrlen( ls_api-data ). WRITE lv_size TO lv_api_bytes NO-GROUPING. CONDENSE lv_api_bytes.
  lv_size = xstrlen( ls_inc-data ). WRITE lv_size TO lv_inc_bytes NO-GROUPING. CONDENSE lv_inc_bytes.
  CONCATENATE '함수 API bytes:' lv_api_bytes INTO lv_a SEPARATED BY space.
  CONCATENATE '활성 Include bytes:' lv_inc_bytes INTO lv_b SEPARATED BY space.
  PERFORM im_proof_emit USING '안내' 0 lv_a 0 lv_b CHANGING ct_rows.
  PERFORM im_decode USING ls_api-data CHANGING lv_a lv_error.
  IF lv_error IS INITIAL. PERFORM im_decode USING ls_inc-data CHANGING lv_b lv_error. ENDIF.
  IF lv_error IS INITIAL. PERFORM im_split USING lv_a CHANGING lt_a lv_error. ENDIF.
  IF lv_error IS INITIAL. PERFORM im_split USING lv_b CHANGING lt_b lv_error. ENDIF.
  IF lv_error IS NOT INITIAL.
    PERFORM im_proof_emit USING '안내' 0 lv_error 0 lv_error CHANGING ct_rows. RETURN.
  ENDIF.
  PERFORM im_tri_align USING lt_a lt_b CHANGING lt_map lv_note.
  IF lv_note IS NOT INITIAL.
    PERFORM im_proof_emit USING '안내' 0 lv_note 0 lv_note CHANGING ct_rows.
  ENDIF.
  LOOP AT lt_map INTO ls_map.
    CLEAR: lv_ha, lv_a, lv_line.
    IF ls_map-slot = 0 AND ls_map-anchor > 0.
      READ TABLE lt_a INTO lv_a INDEX ls_map-anchor.
      IF sy-subrc = 0. lv_ha = 'X'. lv_line = ls_map-anchor. ENDIF.
    ENDIF.
    PERFORM im_tri_kind USING lv_a ls_map-text lv_ha ls_map-present 'X' 'X' CHANGING lv_kind.
    IF lv_kind <> '변경없음'. lv_diff = 'X'. ENDIF.
    PERFORM im_proof_emit USING lv_kind lv_line lv_a ls_map-side_line ls_map-text CHANGING ct_rows.
    DESCRIBE TABLE ct_rows LINES lv_count.
    IF lv_count >= 12000. lv_limited = 'X'. EXIT. ENDIF.
  ENDLOOP.
  IF lv_limited = 'X'.
    DELETE ct_rows INDEX 12000.
    lv_note = '상세 12000행 한도: 나머지 내용은 생략됨. 전체 바이트 불일치 판정은 유지됩니다.'.
    PERFORM im_proof_emit USING '안내' 0 lv_note 0 lv_note CHANGING ct_rows.
  ELSEIF ls_api-data <> ls_inc-data AND lv_diff IS INITIAL.
* Line splitting can hide EOL/BOM/final newline differences. Keep strict
* byte verdict and show the first mismatching byte window explicitly.
    PERFORM im_format_note USING ls_api-data ls_inc-data CHANGING lv_note.
    PERFORM im_status_text USING lv_note CHANGING lv_note.
    CONCATENATE '행 내용은 같지만 전체 바이트가 다릅니다.' lv_note INTO lv_note SEPARATED BY space.
    PERFORM im_proof_emit USING '안내' 0 lv_note 0 lv_note CHANGING ct_rows.
    lv_pos = 0.
    WHILE lv_pos < xstrlen( ls_api-data ) AND lv_pos < xstrlen( ls_inc-data ).
      IF ls_api-data+lv_pos(1) <> ls_inc-data+lv_pos(1). EXIT. ENDIF.
      ADD 1 TO lv_pos.
    ENDWHILE.
    CLEAR: lv_a, lv_b.
    lv_take = xstrlen( ls_api-data ) - lv_pos. IF lv_take > 16. lv_take = 16. ENDIF.
    IF lv_take > 0.
      lv_ax = ls_api-data+lv_pos(lv_take). lv_hex = lv_ax. lv_a = lv_hex.
    ELSE. lv_a = '(파일 끝)'. ENDIF.
    lv_take = xstrlen( ls_inc-data ) - lv_pos. IF lv_take > 16. lv_take = 16. ENDIF.
    IF lv_take > 0.
      lv_bx = ls_inc-data+lv_pos(lv_take). lv_hex = lv_bx. lv_b = lv_hex.
    ELSE. lv_b = '(파일 끝)'. ENDIF.
    lv_line = lv_pos + 1.
    PERFORM im_proof_emit USING '바이트 위치(1부터)' lv_line lv_a lv_line lv_b CHANGING ct_rows.
  ENDIF.
ENDFORM.

FORM im_proof_status USING pt_excluding TYPE slis_t_extab.
  im_screen_mode = 'P'.
  SET PF-STATUS 'STANDARD_FULLSCREEN' OF PROGRAM 'SAPLSLVC_FULLSCREEN' EXCLUDING pt_excluding.
ENDFORM.

FORM im_proof_grid.
  DATA: ls_link TYPE im_function_link, lt_rows TYPE im_proof_rows,
        lt_fcat TYPE slis_t_fieldcat_alv, ls_layout TYPE slis_layout_alv, lv_title TYPE lvc_title.
  PERFORM im_link_get USING im_view_result-path CHANGING ls_link.
  IF ls_link-api_path IS INITIAL. RETURN. ENDIF.
  PERFORM im_proof_build USING ls_link CHANGING lt_rows.
  PERFORM im_view_column USING 'SEQ' '순서' 5 CHANGING lt_fcat.
  PERFORM im_view_column USING 'KIND' 'API 대비 Include' 20 CHANGING lt_fcat.
  PERFORM im_view_column USING 'API_LINE' 'API 행/위치' 10 CHANGING lt_fcat.
  PERFORM im_view_column USING 'API_TEXT' '현재 SAP 함수 API 소스' 52 CHANGING lt_fcat.
  PERFORM im_view_column USING 'INCLUDE_LINE' 'Include 행/위치' 12 CHANGING lt_fcat.
  PERFORM im_view_column USING 'INCLUDE_TEXT' '현재 SAP 활성 Include' 52 CHANGING lt_fcat.
  PERFORM im_view_column USING 'PART' '순번' 4 CHANGING lt_fcat.
  ls_layout-info_fieldname = 'COLOR'.
  lv_title = '함수 API / 활성 Include 대조 (추출본 비교와 별도)'.
  PERFORM im_header_free. im_screen_mode = 'P'.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING i_callback_program = im_program i_callback_pf_status_set = 'IM_PROOF_STATUS'
      i_grid_title = lv_title is_layout = ls_layout it_fieldcat = lt_fcat
    TABLES t_outtab = lt_rows EXCEPTIONS program_error = 1 OTHERS = 2.
  IF sy-subrc <> 0. MESSAGE '활성 소스 대조 화면 표시 실패' TYPE 'I'. ENDIF.
  im_screen_mode = 'D'. CLEAR im_toolbar_grid.
  PERFORM im_header_display USING 'D'.
ENDFORM.

FORM im_json_quote USING pv_value TYPE csequence CHANGING cv_json TYPE string.
* Escape UTF-8 bytes, including every JSON control byte U+0000..U+001F.
* Multibyte Korean characters are copied unchanged, never codepage-converted.
  DATA: lv_text TYPE string, lv_raw TYPE xstring, lv_out TYPE xstring,
        lt_parts TYPE STANDARD TABLE OF xstring, lv_part TYPE xstring,
        lv_byte TYPE x LENGTH 1, lv_hex TYPE c LENGTH 2, lv_offset TYPE i,
        lv_escape TYPE string, lo_conv TYPE REF TO cl_abap_conv_in_ce.
  lv_text = pv_value. PERFORM utf8 USING lv_text CHANGING lv_raw.
  lv_part = '22'. APPEND lv_part TO lt_parts.
  WHILE lv_offset < xstrlen( lv_raw ).
    lv_byte = lv_raw+lv_offset(1). CLEAR lv_part.
    IF lv_byte = '22'. lv_part = '5C22'.
    ELSEIF lv_byte = '5C'. lv_part = '5C5C'.
    ELSEIF lv_byte < '20'.
      lv_hex = lv_byte. CONCATENATE '\u00' lv_hex INTO lv_escape.
      PERFORM utf8 USING lv_escape CHANGING lv_part.
    ELSE. lv_part = lv_byte. ENDIF.
    APPEND lv_part TO lt_parts. ADD 1 TO lv_offset.
  ENDWHILE.
  lv_part = '22'. APPEND lv_part TO lt_parts.
  CONCATENATE LINES OF lt_parts INTO lv_out IN BYTE MODE.
  lo_conv = cl_abap_conv_in_ce=>create( encoding = 'UTF-8' input = lv_out ignore_cerr = space ).
  CALL METHOD lo_conv->read IMPORTING data = cv_json.
ENDFORM.

FORM im_json_put USING pv_key TYPE csequence pv_value TYPE csequence CHANGING cv_fields TYPE string.
  DATA: lv_key TYPE string, lv_value TYPE string.
  PERFORM im_json_quote USING pv_key CHANGING lv_key.
  PERFORM im_json_quote USING pv_value CHANGING lv_value.
  IF cv_fields IS NOT INITIAL. CONCATENATE cv_fields ',' INTO cv_fields. ENDIF.
  CONCATENATE cv_fields lv_key ':' lv_value INTO cv_fields.
ENDFORM.

FORM im_json_row USING ps_result TYPE im_result CHANGING cv_json TYPE string.
  DATA: lt_names TYPE ty_lines, lv_names TYPE string, lv_name TYPE string,
        lv_key TYPE string, lv_value TYPE string, lv_type TYPE c, lv_int TYPE c LENGTH 16,
        lv_match TYPE c, ls_link TYPE im_function_link, lv_link TYPE string.
  FIELD-SYMBOLS <lv_value> TYPE any.
* Enumerate original internal fields, not formatted ALV cells or Excel.
  lv_names = 'ID LIGHT COMPARISON COMPARISON_TEXT ZIP_CHANGE_TEXT SAP_CHANGE_TEXT ZIP_CHANGE SAP_CHANGE'.
  CONCATENATE lv_names 'READ_STATE READ_NOTE READ_TEXT VERSION_STATE VERSION_NOTE VERSION_TEXT'
    'VALIDATION VALIDATION_TEXT VALIDATION_NOTE FORMAT_TEXT XML_AB XML_AC XML_BC'
    'XML_AB_TEXT XML_AC_TEXT XML_BC_TEXT XML_AB_NOTE XML_AC_NOTE XML_NOTE'
    'XML_SCOPE_AB XML_SCOPE_AC XML_SCOPE_CB DEVCLASS OBJECT OBJ_NAME PATH COMPONENT FILENAME'
    'BYTES_A BYTES_B BYTES_C A_OK B_OK C_OK A_STATE B_STATE C_STATE PAIR_AB PAIR_AC PAIR_CB PAIR_NOTE'
    'ACTIVE_A ACTIVE_C AB_FORMAT ERROR_PROGRAM ERROR_LINE MESSAGE'
    'WA_SEL WA_LIGHT WA_READY WA_STATE WA_NOTE WA_URL WA_LANG WA_MIME WA_TASK'
    'WA_AFTER WA_DATE WA_TIME WA_APP WA_PAGE WA_INACTIVE WA_SAVE WA_ACTIVATE WA_PAGE_TYPE'
    'WA_INACTIVE_DETAIL WA_VERIFY_DETAIL' INTO lv_names SEPARATED BY space.
  SPLIT lv_names AT space INTO TABLE lt_names. CLEAR cv_json.
  LOOP AT lt_names INTO lv_name.
    ASSIGN COMPONENT lv_name OF STRUCTURE ps_result TO <lv_value>.
    IF sy-subrc <> 0. CONTINUE. ENDIF.
    lv_key = lv_name. TRANSLATE lv_key TO LOWER CASE.
    DESCRIBE FIELD <lv_value> TYPE lv_type.
    IF lv_type = 'I'.
      WRITE <lv_value> TO lv_int NO-GROUPING. CONDENSE lv_int.
      IF cv_json IS NOT INITIAL. CONCATENATE cv_json ',' INTO cv_json. ENDIF.
      CONCATENATE cv_json '"' lv_key '":' lv_int INTO cv_json.
    ELSE.
      lv_value = <lv_value>.
      PERFORM im_json_put USING lv_key lv_value CHANGING cv_json.
    ENDIF.
  ENDLOOP.
  PERFORM im_filter_match USING ps_result CHANGING lv_match.
  IF lv_match = 'X'. CONCATENATE cv_json ',"selected_by_input_filters":true' INTO cv_json.
  ELSE. CONCATENATE cv_json ',"selected_by_input_filters":false' INTO cv_json. ENDIF.
  PERFORM im_link_get USING ps_result-path CHANGING ls_link.
  IF ls_link-api_path IS NOT INITIAL.
    PERFORM im_json_put USING 'function' ls_link-function_name CHANGING lv_link.
    PERFORM im_json_put USING 'function_group' ls_link-group_name CHANGING lv_link.
    PERFORM im_json_put USING 'include' ls_link-include_name CHANGING lv_link.
    PERFORM im_json_put USING 'api_path' ls_link-api_path CHANGING lv_link.
    PERFORM im_json_put USING 'include_path' ls_link-include_path CHANGING lv_link.
    CONCATENATE cv_json ',"function_link":{' lv_link '}' INTO cv_json.
  ELSE. CONCATENATE cv_json ',"function_link":null' INTO cv_json. ENDIF.
  CONCATENATE '{' cv_json '}' INTO cv_json.
ENDFORM.

FORM im_json_build CHANGING cv_json TYPE string.
  DATA: lt_lines TYPE ty_lines, lv_line TYPE string, lv_meta TYPE string,
        ls_row TYPE im_result, lv_count TYPE i, lv_selected TYPE i, lv_n TYPE c LENGTH 16,
        lv_s TYPE c LENGTH 16, lv_match TYPE c, lv_first TYPE c,
        lv_stamp TYPE string.
  PERFORM im_json_put USING 'tool_version' '0.7.1' CHANGING lv_meta.
  PERFORM im_json_put USING 'package' p_pack CHANGING lv_meta.
  PERFORM im_json_put USING 'export_scope_kind' gv_scope_kind CHANGING lv_meta.
  IF p_bspm = 'X'.
    PERFORM im_json_put USING 'bsp_application' p_bsp CHANGING lv_meta.
  ENDIF.
  PERFORM im_json_put USING 'system_id' sy-sysid CHANGING lv_meta.
  PERFORM im_json_put USING 'client' sy-mandt CHANGING lv_meta.
  lv_stamp = im_started_date.
  PERFORM im_json_put USING 'started_date' lv_stamp CHANGING lv_meta.
  lv_stamp = im_started_time.
  PERFORM im_json_put USING 'started_time' lv_stamp CHANGING lv_meta.
  lv_stamp = im_finished_date.
  PERFORM im_json_put USING 'finished_date' lv_stamp CHANGING lv_meta.
  lv_stamp = im_finished_time.
  PERFORM im_json_put USING 'finished_time' lv_stamp CHANGING lv_meta.
  PERFORM im_json_put USING 'clock_basis' 'SAP system date/time; offset not supplied' CHANGING lv_meta.
  PERFORM im_json_put USING 'input_file' p_file CHANGING lv_meta.
  PERFORM im_json_put USING 'comparison_time_scope' 'PRE_APPLY_SNAPSHOT' CHANGING lv_meta.
  PERFORM im_json_put USING 'web_apply_backup' wa_backup CHANGING lv_meta.
  PERFORM im_json_put USING 'web_apply_journal' wa_journal CHANGING lv_meta.
  PERFORM im_json_put USING 'result_type' im_filter_label CHANGING lv_meta.
  PERFORM im_json_put USING 'scope' 'ALL_RESULTS_BEFORE_SELECTION_AND_ALV_FILTERS' CHANGING lv_meta.
  PERFORM im_json_put USING 'existence_codes' 'P=내용 확보, N=없음 확인, U=미확인; bytes=0만으로 없음 판정 금지' CHANGING lv_meta.
  PERFORM im_json_put USING 'pair_ab' '원본 대비 추출본' CHANGING lv_meta.
  PERFORM im_json_put USING 'pair_ac' '원본 대비 SAP' CHANGING lv_meta.
  PERFORM im_json_put USING 'pair_cb' 'SAP 대비 추출본' CHANGING lv_meta.
  IF p_diff = 'X'. CONCATENATE lv_meta ',"changed_only":true' INTO lv_meta.
  ELSE. CONCATENATE lv_meta ',"changed_only":false' INTO lv_meta. ENDIF.
  DESCRIBE TABLE im_all_results LINES lv_count.
  LOOP AT im_all_results INTO ls_row.
    PERFORM im_filter_match USING ls_row CHANGING lv_match.
    IF lv_match = 'X'. ADD 1 TO lv_selected. ENDIF.
  ENDLOOP.
  WRITE lv_count TO lv_n NO-GROUPING. CONDENSE lv_n.
  WRITE lv_selected TO lv_s NO-GROUPING. CONDENSE lv_s.
  CONCATENATE '{"schema_version":"devhub.diag.results.v1","metadata":{' lv_meta
    '},"total_count":' lv_n ',"selected_count":' lv_s ',"results":[' INTO lv_line.
  APPEND lv_line TO lt_lines. lv_first = 'X'.
  LOOP AT im_all_results INTO ls_row.
    PERFORM im_json_row USING ls_row CHANGING lv_line.
    IF lv_first IS INITIAL. CONCATENATE ',' lv_line INTO lv_line. ENDIF.
    APPEND lv_line TO lt_lines. CLEAR lv_first.
  ENDLOOP.
  lv_line = ']}'. APPEND lv_line TO lt_lines.
  CONCATENATE LINES OF lt_lines INTO cv_json SEPARATED BY gv_lf.
ENDFORM.

FORM im_json_download.
  TYPES: ty_binary TYPE x LENGTH 255.
  DATA: lv_default TYPE string, lv_filename TYPE string, lv_path TYPE string, lv_fullpath TYPE string,
        lv_action TYPE i, lv_json TYPE string, lv_data TYPE xstring, lv_size TYPE i,
        lt_binary TYPE STANDARD TABLE OF ty_binary, lv_binary TYPE ty_binary,
        lv_offset TYPE i, lv_take TYPE i, lv_package TYPE string,
        lo_error TYPE REF TO cx_root, lv_error TYPE string.
  TRY.
      lv_package = p_pack.
      IF p_bspm = 'X'. lv_package = p_bsp. ENDIF.
      REPLACE ALL OCCURRENCES OF '/' IN lv_package WITH '_'.
      CONCATENATE lv_package '_diag_' im_started_date '_' im_started_time '.json' INTO lv_default.
      CALL METHOD cl_gui_frontend_services=>file_save_dialog
        EXPORTING window_title = '전체 진단 결과 JSON 저장' default_extension = 'json'
          default_file_name = lv_default file_filter = 'JSON (*.json)|*.json|'
        CHANGING filename = lv_filename path = lv_path fullpath = lv_fullpath user_action = lv_action
        EXCEPTIONS OTHERS = 1.
      IF sy-subrc <> 0. MESSAGE '저장 경로 선택 실패' TYPE 'I'. RETURN. ENDIF.
      IF lv_action <> 0 OR lv_fullpath IS INITIAL. RETURN. ENDIF.
      PERFORM wa_sync_results.
      PERFORM im_json_build CHANGING lv_json.
      PERFORM utf8 USING lv_json CHANGING lv_data. lv_size = xstrlen( lv_data ).
* Binary transfer of explicit UTF-8 avoids frontend codepage conversion,
* text row limits, CRLF rewriting and trailing-space truncation.
      WHILE lv_offset < lv_size.
        CLEAR lv_binary. lv_take = lv_size - lv_offset. IF lv_take > 255. lv_take = 255. ENDIF.
        lv_binary = lv_data+lv_offset(lv_take). APPEND lv_binary TO lt_binary.
        ADD lv_take TO lv_offset.
      ENDWHILE.
      CALL METHOD cl_gui_frontend_services=>gui_download
        EXPORTING filename = lv_fullpath filetype = 'BIN' bin_filesize = lv_size
        CHANGING data_tab = lt_binary EXCEPTIONS OTHERS = 1.
      IF sy-subrc <> 0. MESSAGE 'JSON 저장 실패. 저장경로와 파일 권한을 확인하세요.' TYPE 'I'.
      ELSE. MESSAGE '조회조건 적용 전 전체 진단 결과를 JSON으로 저장했습니다.' TYPE 'S'. ENDIF.
    CATCH cx_root INTO lo_error.
      lv_error = lo_error->get_text( ). MESSAGE lv_error TYPE 'I'.
  ENDTRY.
ENDFORM.

* ---------------- Web asset replacement, DIAG 0.7.1 ------------------
FORM wa_is_web USING ps_row TYPE im_result CHANGING cv_web TYPE c.
  DATA lv_path TYPE string.
  CLEAR cv_web. lv_path = ps_row-path. TRANSLATE lv_path TO LOWER CASE.
  IF ps_row-component = 'MIME_CONTENT' OR ps_row-component = 'W3MI_CONTENT' OR
     ps_row-component = 'BSP_LAYOUT'. cv_web = 'X'. RETURN. ENDIF.
  IF ps_row-component = 'MIME_METADATA' OR ps_row-component = 'W3MI_METADATA' OR
     ps_row-component = 'WEB_CATALOG' OR lv_path CP '*/metadata.xml'. RETURN. ENDIF.
* Unknown new web files remain visible for diagnosis; mapping/write guards
* still reject them. Extension/path classification is never a write key.
  IF lv_path CP '*.html' OR lv_path CP '*.htm' OR lv_path CP '*.js' OR
     lv_path CP '*.css' OR lv_path CP 'packages/*/mime/*' OR
     lv_path CP '*/mimes/*' OR lv_path CP 'mimes/*'.
    cv_web = 'X'.
  ENDIF.
ENDFORM.

FORM wa_toolbar USING po_toolbar TYPE REF TO cl_alv_event_toolbar_set.
  DATA ls_button TYPE stb_button.
  DELETE po_toolbar->mt_toolbar WHERE function = 'ZSAVE' OR function = 'ZWA_LOG'.
  IF im_screen_mode <> 'M' OR p_mime <> 'X'. RETURN. ENDIF.
  ls_button-function = 'ZSAVE'. ls_button-text = '선택 저장/활성화'.
  ls_button-quickinfo = 'MIME 저장 또는 BSP Layout 저장·페이지 활성화 및 재검증'.
  ls_button-disabled = wa_busy.
  INSERT ls_button INTO po_toolbar->mt_toolbar INDEX 1.
  CLEAR ls_button. ls_button-function = 'ZWA_LOG'.
  ls_button-text = '반영 로그 저장'.
  ls_button-quickinfo = '백업 경로·단계·결과를 XML로 저장'.
  INSERT ls_button INTO po_toolbar->mt_toolbar INDEX 2.
ENDFORM.

FORM wa_columns.
  FIELD-SYMBOLS <ls_col> TYPE slis_fieldcat_alv.
  IF p_mime <> 'X'. RETURN. ENDIF.
  PERFORM im_column USING 'WA_SEL' '선택' 4.
  READ TABLE im_fcat ASSIGNING <ls_col> WITH KEY fieldname = 'WA_SEL'.
  IF sy-subrc = 0.
    <ls_col>-checkbox = 'X'. <ls_col>-edit = 'X'.
    <ls_col>-key = 'X'. <ls_col>-fix_column = 'X'.
  ENDIF.
  PERFORM im_column USING 'WA_LIGHT' '반영등' 6.
  READ TABLE im_fcat ASSIGNING <ls_col> WITH KEY fieldname = 'WA_LIGHT'.
  IF sy-subrc = 0. <ls_col>-icon = 'X'. ENDIF.
  PERFORM im_column USING 'WA_STATE' '반영 상태' 22.
  PERFORM im_column USING 'WA_NOTE' '반영 설명' 54.
  PERFORM im_column USING 'WA_SAVE' '저장 결과' 20.
  PERFORM im_column USING 'WA_ACTIVATE' '활성화 결과' 22.
  PERFORM im_column USING 'WA_INACTIVE' '대상 미활성 점검' 16.
  PERFORM im_column USING 'WA_APP' 'BSP 애플리케이션' 24.
  PERFORM im_column USING 'WA_PAGE' 'BSP 페이지 키' 32.
  PERFORM im_column USING 'WA_PAGE_TYPE' 'BSP 페이지 유형' 28.
  PERFORM im_column USING 'WA_URL' '서버 경로/파일명' 48.
  PERFORM im_column USING 'WA_LANG' '실제 언어' 8.
  PERFORM im_column USING 'WA_MIME' 'MIME 유형' 24.
  PERFORM im_column USING 'WA_TASK' 'CTS 작업' 20.
  PERFORM im_column USING 'WA_AFTER' '반영 후 bytes' 12.
  PERFORM im_column USING 'WA_DATE' '반영 확인일' 10.
  PERFORM im_column USING 'WA_TIME' '반영 확인시각' 12.
ENDFORM.

FORM wa_metadata USING pv_path TYPE string CHANGING cv_data TYPE xstring
                                                   cv_error TYPE string.
  DATA: ls_file TYPE ty_file, lv_b TYPE xstring, lv_c TYPE xstring,
        lv_aok TYPE c, lv_bok TYPE c, lv_cok TYPE c.
  CLEAR: cv_data, cv_error.
  READ TABLE im_manifest_index INTO ls_file WITH TABLE KEY path = pv_path.
  IF sy-subrc <> 0.
    cv_error = '원본 manifest에 매핑 메타데이터가 없습니다.'. RETURN.
  ENDIF.
  IF ls_file-component <> 'WEB_CATALOG' AND
     ls_file-component <> 'MIME_METADATA' AND
     ls_file-component <> 'W3MI_METADATA' AND
     ls_file-component <> 'BSP_PAGE_PATH_MAP' AND
     ls_file-component <> 'BSP_ATTRIBUTES'.
    cv_error = '매핑 경로가 허용된 메타데이터가 아닙니다.'. RETURN.
  ENDIF.
  PERFORM im_triplet USING ls_file CHANGING cv_data lv_b lv_c
    lv_aok lv_bok lv_cok.
  IF lv_aok <> 'X' OR lv_bok <> 'X' OR cv_data <> lv_b.
    cv_error = '매핑 XML 또는 baseline 변경/누락: 원래 Export 메타데이터를 복원하십시오.'.
    RETURN.
  ENDIF.
  PERFORM im_xml USING cv_data CHANGING cv_error.
ENDFORM.

FORM wa_gate USING pv_object TYPE c pv_component TYPE c pv_mode TYPE c
                   pv_aok TYPE c pv_bok TYPE c pv_cok TYPE c
                   pv_a TYPE xstring pv_b TYPE xstring pv_c TYPE xstring
             CHANGING cv_ready TYPE c cv_state TYPE c cv_note TYPE c.
* Pure decision rule; called by preparation and the executable regression test.
  CLEAR cv_ready. cv_state = 'BLOCKED'.
  cv_note = '기존 SMIM/W3MI RAW 콘텐츠 교체만 지원합니다.'.
  IF NOT ( ( pv_object = 'SMIM' AND pv_component = 'MIME_CONTENT' ) OR
           ( pv_object = 'W3MI' AND pv_component = 'W3MI_CONTENT' ) ).
    RETURN.
  ENDIF.
  IF pv_mode <> 'RAW'. cv_note = 'RAW 바이트 원본이 아니므로 저장하지 않습니다.'. RETURN. ENDIF.
  IF pv_aok <> 'X' OR pv_bok <> 'X' OR pv_cok <> 'X'.
    cv_note = '원본·추출본·SAP 모두 읽어야 합니다. 신규/삭제/조회실패는 저장할 수 없습니다.'.
    RETURN.
  ENDIF.
  IF pv_b = pv_c.
    cv_state = 'ALREADY_EQUAL'. cv_note = '진단 시점 SAP와 동일: 저장 불필요.'. RETURN.
  ENDIF.
  IF pv_a = pv_b.
    cv_state = 'UPLOAD_UNCHANGED'.
    cv_note = '추출본은 수정되지 않았습니다. SAP 변경을 되돌리는 저장은 차단합니다.'. RETURN.
  ENDIF.
  IF pv_a <> pv_c.
    cv_state = 'CONFLICT'.
    cv_note = 'Export 이후 SAP도 변경됨: 최신 패키지를 재추출하고 변경을 병합하십시오.'. RETURN.
  ENDIF.
  cv_ready = 'X'. cv_state = 'READY'.
  cv_note = '저장 후보: 선택 실행 시 API·권한·CTS·잠금·최신 바이트를 다시 점검합니다.'.
ENDFORM.

FORM wa_prepare.
  DATA: lv_raw TYPE xstring, lv_error TYPE string, lv_path TYPE string,
        lv_a TYPE xstring, lv_b TYPE xstring, lv_c TYPE xstring,
        lv_aok TYPE c, lv_bok TYPE c, lv_cok TYPE c, ls_live TYPE ty_file,
        ls_asset TYPE ty_web_asset, ls_current TYPE ty_web_asset,
        lt_meta TYPE STANDARD TABLE OF ty_mime_metadata,
        ls_meta TYPE ty_mime_metadata, ls_mc TYPE ty_mime_metadata,
        ls_target TYPE wa_target, lv_count TYPE i, lv_web TYPE c,
        lo_error TYPE REF TO cx_root.
  FIELD-SYMBOLS <ls_row> TYPE im_result.
  lv_path = 'catalog/web-assets.xml'.
  PERFORM wa_metadata USING lv_path CHANGING lv_raw wa_catalog_error.
  IF wa_catalog_error IS INITIAL.
    TRY.
        CALL TRANSFORMATION id SOURCE XML lv_raw RESULT assets = wa_assets_a.
      CATCH cx_root INTO lo_error.
        wa_catalog_error = lo_error->get_text( ).
    ENDTRY.
  ENDIF.
  LOOP AT im_results ASSIGNING <ls_row>.
    PERFORM wa_is_web USING <ls_row> CHANGING lv_web.
    IF lv_web IS INITIAL. CONTINUE. ENDIF.
    <ls_row>-wa_light = '@09@'. <ls_row>-wa_state = 'BLOCKED'.
    <ls_row>-wa_save = 'NOT_RUN'. <ls_row>-wa_activate = 'NOT_APPLICABLE'.
    IF p_bspm = 'X'.
      READ TABLE im_manifest_index INTO ls_live WITH TABLE KEY path = <ls_row>-path.
      IF sy-subrc <> 0.
        <ls_row>-wa_note = '원본 목록 밖의 파일은 저장하지 않습니다.'. CONTINUE.
      ENDIF.
      PERFORM im_scope_current USING ls_live CHANGING lv_web.
      IF lv_web <> 'X'.
        <ls_row>-wa_note = '선택한 BSP의 현재 객체 범위 밖입니다.'. CONTINUE.
      ENDIF.
    ENDIF.
    IF <ls_row>-component = 'BSP_LAYOUT'.
      PERFORM wa_bsp_prepare CHANGING <ls_row>.
      CONTINUE.
    ENDIF.
    IF wa_catalog_error IS NOT INITIAL.
      <ls_row>-wa_note = wa_catalog_error. CONTINUE.
    ENDIF.
    CLEAR: ls_target, lv_error, ls_current, ls_live, ls_meta, ls_mc.
    lv_path = <ls_row>-path.
    READ TABLE im_manifest_index INTO ls_target-file WITH TABLE KEY path = lv_path.
    IF sy-subrc <> 0.
      <ls_row>-wa_note = '원본 manifest 밖의 신규 파일: 생성/이름 변경은 지원하지 않습니다.'. CONTINUE.
    ENDIF.
    PERFORM im_triplet USING ls_target-file CHANGING lv_a lv_b lv_c
      lv_aok lv_bok lv_cok.
    PERFORM wa_gate USING <ls_row>-object <ls_row>-component ls_target-file-check_mode
      lv_aok lv_bok lv_cok lv_a lv_b lv_c CHANGING <ls_row>-wa_ready
      <ls_row>-wa_state <ls_row>-wa_note.
    CLEAR lv_count.
    LOOP AT wa_assets_a INTO ls_asset WHERE content_path = lv_path.
      ADD 1 TO lv_count. ls_target-asset = ls_asset.
    ENDLOOP.
    IF lv_count <> 1. lv_error = '원본 카탈로그의 콘텐츠 경로가 유일하지 않거나 없습니다.'. ENDIF.
    ls_asset = ls_target-asset.
    CLEAR lv_count.
    LOOP AT gt_web_assets INTO ls_current WHERE content_path = lv_path.
      ADD 1 TO lv_count.
    ENDLOOP.
    IF lv_count <> 1. lv_error = '현재 SAP 카탈로그의 경로가 유일하지 않거나 없습니다.'. ENDIF.
    READ TABLE im_current_index INTO ls_live WITH TABLE KEY path = lv_path.
    IF sy-subrc <> 0 OR ls_live-object <> ls_target-file-object OR
       ls_live-obj_name <> ls_target-file-obj_name OR
       ls_live-devclass <> ls_target-file-devclass OR
       ls_live-component <> ls_target-file-component OR ls_live-check_mode <> 'RAW'.
      lv_error = 'manifest와 현재 SAP 콘텐츠 매핑이 다릅니다.'.
    ENDIF.
    IF ls_asset-object <> ls_target-file-object OR
       ls_asset-obj_name <> ls_target-file-obj_name OR
       ls_asset-devclass <> ls_target-file-devclass OR
       ls_asset-language <> ls_target-file-language OR
       ls_asset-status <> 'EXPORTED' OR ls_current-status <> 'EXPORTED' OR
       ls_asset-object <> ls_current-object OR ls_asset-obj_name <> ls_current-obj_name OR
       ls_asset-devclass <> ls_current-devclass OR ls_asset-kind <> ls_current-kind OR
       ls_asset-language <> ls_current-language OR ls_asset-component <> ls_current-component OR
       ls_asset-original_path <> ls_current-original_path OR
       ls_asset-metadata_path <> ls_current-metadata_path OR
       ls_asset-mime_type <> ls_current-mime_type.
      lv_error = '원본/현재 SAP의 객체·경로·언어·MIME 매핑 불일치.'.
    ENDIF.
    IF ls_asset-kind <> 'MIME_FILE' AND ls_asset-kind <> 'WEB_MIME_FILE'.
      lv_error = '파일 콘텐츠 유형이 아닙니다.'.
    ENDIF.
    READ TABLE gt_seen_pkg WITH TABLE KEY devclass = ls_target-file-devclass TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0 OR <ls_row>-comparison = 'MAPPING_REJECTED' OR
       <ls_row>-comparison = 'OUT_OF_SCOPE'. lv_error = '선택 패키지 범위/매핑 검사 실패.'. ENDIF.
    IF lv_error IS INITIAL.
      PERFORM wa_metadata USING ls_asset-metadata_path CHANGING lv_raw lv_error.
    ENDIF.
    IF lv_error IS INITIAL AND ls_asset-object = 'SMIM'.
      TRY.
          REFRESH lt_meta.
          CALL TRANSFORMATION id SOURCE XML lv_raw RESULT entries = lt_meta.
          CLEAR lv_count.
          LOOP AT lt_meta INTO ls_meta WHERE content_path = lv_path.
            ADD 1 TO lv_count. ls_target-meta = ls_meta.
          ENDLOOP.
          IF lv_count <> 1. lv_error = '원본 LOIO 메타데이터가 유일하지 않습니다.'. ENDIF.
        CATCH cx_root INTO lo_error. lv_error = lo_error->get_text( ).
      ENDTRY.
      ls_meta = ls_target-meta. CLEAR lv_count.
      LOOP AT gt_mime_metadata INTO ls_mc WHERE content_path = lv_path.
        ADD 1 TO lv_count.
      ENDLOOP.
      IF lv_count <> 1 OR ls_meta-loio <> ls_asset-obj_name OR
         ls_meta-object <> 'SMIM' OR ls_meta-obj_name <> ls_asset-obj_name OR
         ls_meta-devclass <> ls_asset-devclass OR ls_meta-url <> ls_asset-original_path OR
         ls_meta-is_folder = 'X' OR ls_meta-actual_language <> ls_asset-language OR
         ls_meta-mime_type <> ls_asset-mime_type OR ls_meta-status <> 'EXPORTED' OR
         ls_mc-loio <> ls_meta-loio OR ls_mc-url <> ls_meta-url OR
         ls_mc-actual_language <> ls_meta-actual_language OR ls_mc-is_folder = 'X' OR
         ls_mc-mime_type <> ls_meta-mime_type OR ls_mc-phio IS INITIAL.
        lv_error = 'LOIO·서버 URL·언어·PHIO 메타데이터 검사 실패.'.
      ENDIF.
      ls_target-meta = ls_mc. ls_target-phio = ls_mc-phio.
    ENDIF.
    IF lv_error IS INITIAL AND ls_asset-object = 'W3MI'.
      TRY.
          CALL TRANSFORMATION id SOURCE XML lv_raw RESULT parameters = ls_target-params.
          SORT ls_target-params BY relid objid name.
          IF ls_target-params IS INITIAL. lv_error = '원본 W3MI 매개변수가 없습니다.'. ENDIF.
        CATCH cx_root INTO lo_error. lv_error = lo_error->get_text( ).
      ENDTRY.
    ENDIF.
    <ls_row>-wa_url = ls_asset-original_path. <ls_row>-wa_lang = ls_asset-language.
    <ls_row>-wa_mime = ls_asset-mime_type.
    IF lv_error IS NOT INITIAL.
      CLEAR <ls_row>-wa_ready. <ls_row>-wa_state = 'BLOCKED'.
      <ls_row>-wa_note = lv_error. CONTINUE.
    ENDIF.
    IF <ls_row>-wa_ready <> 'X'. CONTINUE. ENDIF.
    ls_target-id = <ls_row>-id. ls_target-before = lv_c.
    ls_target-wanted = lv_b. ls_target-eligible = 'X'.
    APPEND ls_target TO wa_targets.
  ENDLOOP.
ENDFORM.

FORM wa_cts CHANGING cs_target TYPE wa_target cv_error TYPE string.
  DATA: lv_fm TYPE rs38l-name, lv_task TYPE e070-trkorr,
        lv_package TYPE tadir-devclass, lv_rc TYPE sysubrc, lv_key TYPE e071-trkorr.
  CLEAR cv_error. lv_fm = 'RS_CORR_INSERT'.
  IF cs_target-file-devclass <> '$TMP'. lv_task = p_task. ENDIF.
  CALL FUNCTION lv_fm EXPORTING object = cs_target-file-obj_name
    object_class = cs_target-file-object devclass = cs_target-file-devclass
    korrnum = lv_task global_lock = 'X' suppress_dialog = 'X'
    IMPORTING korrnum = cs_target-task devclass = lv_package
    EXCEPTIONS error_message = 1 OTHERS = 2.
  lv_rc = sy-subrc.
  IF lv_rc <> 0. PERFORM wa_api_error USING lv_fm lv_rc CHANGING cv_error. RETURN. ENDIF.
  IF lv_package <> cs_target-file-devclass.
    cv_error = 'CTS가 반환한 패키지가 대상과 다릅니다.'. RETURN.
  ENDIF.
  IF cs_target-file-devclass = '$TMP'. RETURN. ENDIF.
  IF cs_target-task <> p_task.
    cv_error = 'CTS가 지정한 작업과 다른 번호를 반환했습니다.'. RETURN.
  ENDIF.
  SELECT SINGLE trkorr FROM e071 INTO lv_key WHERE trkorr = cs_target-task
    AND pgmid = 'R3TR' AND object = cs_target-file-object AND obj_name = cs_target-file-obj_name.
  IF sy-subrc <> 0. cv_error = 'CTS 작업의 R3TR 객체 등록을 확인하지 못했습니다.'. ENDIF.
ENDFORM.

FORM wa_put USING ps_target TYPE wa_target CHANGING cv_error TYPE string.
  DATA: lo_api TYPE REF TO if_mr_api, lv_method TYPE string, lv_fm TYPE rs38l-name,
        lv_rc TYPE sysubrc, lv_task TYPE trkorr,
        ls_key TYPE wwwdatatab, lt_params TYPE STANDARD TABLE OF wwwparams,
        ls_param TYPE wwwparams, lt_mime TYPE STANDARD TABLE OF w3mime,
        lv_size TYPE i, lv_out TYPE i, lv_name TYPE string,
        lv_roundtrip TYPE xstring, lv_ok TYPE c.
  CLEAR cv_error.
  PERFORM wa_scope_check USING ps_target CHANGING cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
* Mandatory backend guard. UI visibility or filename alone never authorizes writing.
  IF p_mime <> 'X' OR wa_busy <> 'X' OR ps_target-selected <> 'X' OR
     ps_target-eligible <> 'X' OR ps_target-locked <> 'X' OR
     wa_backup IS INITIAL OR wa_journal_owned <> 'X'.
    cv_error = 'WRITE_CONTEXT_REJECTED'. RETURN.
  ENDIF.
  IF ps_target-file-object = 'SMIM' AND ps_target-file-component = 'MIME_CONTENT' AND
     ps_target-file-check_mode = 'RAW' AND ps_target-asset-kind = 'MIME_FILE'.
    lo_api = cl_mime_repository_api=>get_api( ).
    lv_method = 'PUT'. lv_task = ps_target-task.
* Explicit blank language is significant: do not substitute SY-LANGU.
* No I_NEW_LOIO, folder creation, metadata edits, or direct table updates.
    CALL METHOD lo_api->(lv_method) EXPORTING i_url = ps_target-meta-url
      i_content = ps_target-wanted i_language = ps_target-meta-actual_language
      i_dev_package = ps_target-file-devclass i_corr_number = lv_task
      i_check_authority = 'X' EXCEPTIONS OTHERS = 1.
    lv_rc = sy-subrc.
    IF lv_rc <> 0. PERFORM wa_api_error USING 'MIME PUT' lv_rc CHANGING cv_error. ENDIF.
  ELSEIF ps_target-file-object = 'W3MI' AND ps_target-file-component = 'W3MI_CONTENT' AND
         ps_target-file-check_mode = 'RAW' AND ps_target-asset-kind = 'WEB_MIME_FILE'.
    lv_size = xstrlen( ps_target-wanted ).
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY' EXPORTING buffer = ps_target-wanted
      IMPORTING output_length = lv_out TABLES binary_tab = lt_mime.
    PERFORM web_binary USING lt_mime lv_size CHANGING lv_roundtrip lv_ok.
    IF lv_out <> lv_size OR lv_ok <> 'X' OR lv_roundtrip <> ps_target-wanted.
      cv_error = 'W3MI binary table conversion failed'. RETURN.
    ENDIF.
    lt_params = ps_target-params. ls_key = ps_target-wwwkey.
    LOOP AT lt_params INTO ls_param.
      lv_name = ls_param-name. TRANSLATE lv_name TO LOWER CASE.
      IF lv_name = 'filesize'.
        WRITE lv_size TO ls_param-value LEFT-JUSTIFIED NO-GROUPING.
        CONDENSE ls_param-value. MODIFY lt_params FROM ls_param.
      ENDIF.
    ENDLOOP.
    GET TIME. ls_key-tdate = sy-datum. ls_key-ttime = sy-uzeit. ls_key-chname = sy-uname.
    ls_key-devclass = ps_target-file-devclass. lv_fm = 'WWWDATA_EXPORT'.
    CALL FUNCTION lv_fm EXPORTING key = ls_key TABLES mime = lt_mime
      EXCEPTIONS error_message = 1 OTHERS = 2.
    lv_rc = sy-subrc.
    IF lv_rc <> 0. PERFORM wa_api_error USING lv_fm lv_rc CHANGING cv_error. RETURN. ENDIF.
    lv_fm = 'WWWPARAMS_UPDATE'.
    CALL FUNCTION lv_fm TABLES params = lt_params EXCEPTIONS error_message = 1 OTHERS = 2.
    lv_rc = sy-subrc.
    IF lv_rc <> 0. PERFORM wa_api_error USING lv_fm lv_rc CHANGING cv_error. ENDIF.
  ELSE.
    cv_error = 'WRITE_TYPE_REJECTED: MIME adapter only; BSP uses the page adapter'.
  ENDIF.
ENDFORM.

FORM wa_cts_verify USING ps_target TYPE wa_target CHANGING cv_error TYPE string.
  DATA lv_task TYPE e071-trkorr.
  CLEAR cv_error.
  IF ps_target-file-devclass = '$TMP'. RETURN. ENDIF.
  IF ps_target-task IS INITIAL OR ps_target-task <> p_task.
    cv_error = '반영 후 CTS 작업 식별자 불일치'. RETURN.
  ENDIF.
  SELECT SINGLE trkorr FROM e071 INTO lv_task WHERE trkorr = ps_target-task
    AND pgmid = 'R3TR' AND object = ps_target-file-object AND obj_name = ps_target-file-obj_name.
  IF sy-subrc <> 0. cv_error = '반영 후 CTS 작업에서 객체 등록을 확인하지 못했습니다.'. ENDIF.
ENDFORM.

FORM wa_event_add USING pv_id TYPE i pv_path TYPE string pv_phase TYPE csequence
                         pv_state TYPE csequence pv_detail TYPE string.
  DATA ls_event TYPE wa_event.
  DESCRIBE TABLE wa_events LINES ls_event-seq. ADD 1 TO ls_event-seq.
  GET TIME. ls_event-id = pv_id. ls_event-run = wa_run. ls_event-path = pv_path.
  ls_event-phase = pv_phase. ls_event-state = pv_state. ls_event-detail = pv_detail.
  ls_event-user_name = sy-uname. ls_event-date = sy-datum. ls_event-time = sy-uzeit.
  APPEND ls_event TO wa_events.
ENDFORM.

FORM wa_set_result USING pv_id TYPE i pv_state TYPE csequence pv_note TYPE string
                         pv_light TYPE csequence pv_after TYPE i pv_task TYPE e070-trkorr.
  FIELD-SYMBOLS <ls_row> TYPE im_result.
  READ TABLE im_results ASSIGNING <ls_row> WITH KEY id = pv_id.
  IF sy-subrc <> 0. RETURN. ENDIF.
  <ls_row>-wa_state = pv_state. <ls_row>-wa_note = pv_note.
  <ls_row>-wa_light = pv_light. <ls_row>-wa_after = pv_after. <ls_row>-wa_task = pv_task.
  IF <ls_row>-object = 'SMIM' OR <ls_row>-object = 'W3MI'.
    <ls_row>-wa_save = pv_state. <ls_row>-wa_activate = 'NOT_APPLICABLE'.
  ENDIF.
  IF pv_state = 'SAVED_VERIFIED' OR pv_state = 'ACTIVATED_VERIFIED'.
    GET TIME. <ls_row>-wa_date = sy-datum. <ls_row>-wa_time = sy-uzeit.
  ENDIF.
ENDFORM.

FORM wa_sync_results.
  DATA ls_visible TYPE im_result.
  FIELD-SYMBOLS <ls_all> TYPE im_result.
  LOOP AT im_results INTO ls_visible.
    READ TABLE im_all_results ASSIGNING <ls_all> WITH KEY id = ls_visible-id.
    IF sy-subrc = 0. <ls_all> = ls_visible. ENDIF.
  ENDLOOP.
ENDFORM.

FORM wa_write_file USING pv_path TYPE string pv_data TYPE xstring pv_new TYPE c
                  CHANGING cv_error TYPE string.
* Binary download plus binary upload equality, including trailing zero bytes.
  DATA: lv_exists TYPE abap_bool, lt_bytes TYPE ty_binary, ls_bytes TYPE ty_binary_line,
        lv_offset TYPE i, lv_take TYPE i, lv_size TYPE i, lv_read_size TYPE i,
        lv_check TYPE xstring, lv_ok TYPE c, lo_error TYPE REF TO cx_root.
  CLEAR cv_error.
  TRY.
      IF pv_new = 'X'.
        CALL METHOD cl_gui_frontend_services=>file_exist EXPORTING file = pv_path
          RECEIVING result = lv_exists EXCEPTIONS OTHERS = 1.
        IF sy-subrc <> 0 OR lv_exists = 'X'.
          cv_error = '새 백업/로그 파일명을 선택하십시오. 기존 파일을 덮어쓰지 않습니다.'. RETURN.
        ENDIF.
      ENDIF.
      lv_size = xstrlen( pv_data ).
      WHILE lv_offset < lv_size.
        CLEAR ls_bytes. lv_take = lv_size - lv_offset.
        IF lv_take > 255. lv_take = 255. ENDIF.
        ls_bytes = pv_data+lv_offset(lv_take). APPEND ls_bytes TO lt_bytes.
        ADD lv_take TO lv_offset.
      ENDWHILE.
      CALL METHOD cl_gui_frontend_services=>gui_download EXPORTING filename = pv_path
        filetype = 'BIN' bin_filesize = lv_size CHANGING data_tab = lt_bytes EXCEPTIONS OTHERS = 1.
      IF sy-subrc <> 0. cv_error = '백업/로그 파일 저장 실패'. RETURN. ENDIF.
      REFRESH lt_bytes.
      CALL METHOD cl_gui_frontend_services=>gui_upload EXPORTING filename = pv_path filetype = 'BIN'
        IMPORTING filelength = lv_read_size CHANGING data_tab = lt_bytes EXCEPTIONS OTHERS = 1.
      IF sy-subrc <> 0 OR lv_read_size <> lv_size.
        cv_error = '백업/로그 파일 재읽기 실패 또는 길이 불일치'. RETURN.
      ENDIF.
* WEB_BINARY has a 16 MiB asset limit. A backup ZIP may be larger.
      CLEAR lv_offset.
      LOOP AT lt_bytes INTO ls_bytes.
        lv_take = lv_size - lv_offset. IF lv_take > 255. lv_take = 255. ENDIF.
        IF lv_take <= 0. cv_error = '백업 재읽기 초과 데이터'. RETURN. ENDIF.
        CONCATENATE lv_check ls_bytes(lv_take) INTO lv_check IN BYTE MODE.
        ADD lv_take TO lv_offset.
      ENDLOOP.
      IF lv_check <> pv_data. cv_error = '백업/로그 재읽기 바이트 불일치'. ENDIF.
    CATCH cx_root INTO lo_error. cv_error = lo_error->get_text( ).
  ENDTRY.
ENDFORM.

FORM wa_log_raw CHANGING cv_raw TYPE xstring.
  DATA: lt_targets TYPE STANDARD TABLE OF ty_web_asset,
        lt_mapping TYPE STANDARD TABLE OF ty_mime_metadata,
        lt_results TYPE STANDARD TABLE OF im_result, ls_row TYPE im_result,
        ls_target TYPE wa_target.
  PERFORM wa_sync_results.
  LOOP AT wa_targets INTO ls_target WHERE selected = 'X'.
    APPEND ls_target-asset TO lt_targets.
    IF ls_target-file-object = 'SMIM'. APPEND ls_target-meta TO lt_mapping. ENDIF.
    READ TABLE im_all_results INTO ls_row WITH KEY id = ls_target-id.
    IF sy-subrc = 0. APPEND ls_row TO lt_results. ENDIF.
  ENDLOOP.
  CALL TRANSFORMATION id SOURCE report_version = '0.7.1'
    system_id = sy-sysid client = sy-mandt basis = sy-saprl
    user_name = sy-uname input_zip = p_file backup_zip = wa_backup
    export_scope = im_header
    cts_task = p_task selected_targets = lt_targets original_mime_mapping = lt_mapping
    comparison_scope = 'PRE_APPLY_SNAPSHOT; WA_* fields describe post-apply outcomes'
    activation_scope = 'Existing MIME save; BSP Layout SET_PAGE/SAVE plus one WAPP activation; no ITS publish'
    browser_test = 'NOT_PERFORMED; HTTP/cache/runtime must be checked separately'
    results = lt_results events = wa_events RESULT XML cv_raw.
ENDFORM.

FORM wa_flush CHANGING cv_error TYPE string.
  DATA: lv_raw TYPE xstring, lv_new TYPE c, lo_error TYPE REF TO cx_root.
  CLEAR cv_error.
  IF wa_journal IS INITIAL. cv_error = '실행 로그 경로가 없습니다.'. RETURN. ENDIF.
  TRY.
      PERFORM wa_log_raw CHANGING lv_raw.
      IF wa_journal_owned IS INITIAL. lv_new = 'X'. ENDIF.
      PERFORM wa_write_file USING wa_journal lv_raw lv_new CHANGING cv_error.
      IF cv_error IS INITIAL. wa_journal_owned = 'X'. ENDIF.
    CATCH cx_root INTO lo_error. cv_error = lo_error->get_text( ).
  ENDTRY.
ENDFORM.

FORM wa_log_download.
  DATA: lv_file TYPE string, lv_path TYPE string, lv_full TYPE string,
        lv_action TYPE i, lv_raw TYPE xstring, lv_error TYPE string, lo_error TYPE REF TO cx_root.
  TRY.
      lv_file = 'DIAG_WEBAPPLY_RUN.xml'.
      CALL METHOD cl_gui_frontend_services=>file_save_dialog
        EXPORTING window_title = '웹자산 실행 로그 저장' default_extension = 'xml' default_file_name = lv_file
        CHANGING filename = lv_file path = lv_path fullpath = lv_full user_action = lv_action
        EXCEPTIONS OTHERS = 1.
      IF sy-subrc <> 0 OR lv_action <> 0 OR lv_full IS INITIAL. RETURN. ENDIF.
      PERFORM wa_log_raw CHANGING lv_raw.
      PERFORM wa_write_file USING lv_full lv_raw 'X' CHANGING lv_error.
      IF lv_error IS NOT INITIAL. MESSAGE lv_error TYPE 'I'.
      ELSE. MESSAGE '반영 로그를 저장하고 재읽기로 확인했습니다.' TYPE 'S'. ENDIF.
    CATCH cx_root INTO lo_error.
      lv_error = lo_error->get_text( ). MESSAGE lv_error TYPE 'I'.
  ENDTRY.
ENDFORM.

FORM wa_backup_build CHANGING cv_raw TYPE xstring cv_error TYPE string.
  DATA: lo_zip TYPE REF TO cl_abap_zip, lt_files TYPE im_files,
        lt_paths TYPE im_paths, lv_path TYPE string, ls_file TYPE ty_file,
        ls_target TYPE wa_target, lv_a TYPE xstring, lv_b TYPE xstring,
        lv_meta TYPE xstring, lv_text TYPE string, ls_header TYPE ty_header,
        lt_params TYPE STANDARD TABLE OF wwwparams, ls_param TYPE wwwparams,
        lt_api TYPE STANDARD TABLE OF fupararef, lv_name TYPE string, lv_size TYPE i, lv_prefix_len TYPE i,
        lo_error TYPE REF TO cx_root, lv_zip_path TYPE string.
  CLEAR: cv_raw, cv_error.
  TRY.
      CREATE OBJECT lo_zip.
      lv_path = 'catalog/web-assets.xml'. INSERT lv_path INTO TABLE lt_paths.
      LOOP AT wa_targets INTO ls_target WHERE selected = 'X'.
        INSERT ls_target-file-path INTO TABLE lt_paths.
        INSERT ls_target-asset-metadata_path INTO TABLE lt_paths.
        IF ls_target-file-object = 'WAPA'.
          INSERT ls_target-bsp_map INTO TABLE lt_paths.
          lv_prefix_len = strlen( ls_target-bsp_prefix ).
          LOOP AT im_manifest_index INTO ls_file.
            IF strlen( ls_file-path ) < lv_prefix_len. CONTINUE. ENDIF.
            IF ls_file-path(lv_prefix_len) = ls_target-bsp_prefix AND
               ls_file-object = 'WAPA' AND ls_file-obj_name = ls_target-file-obj_name.
              lv_path = ls_file-path. INSERT lv_path INTO TABLE lt_paths.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDLOOP.
      LOOP AT lt_paths INTO lv_path.
        CLEAR: lv_a, lv_b, ls_file.
        READ TABLE im_manifest_index INTO ls_file WITH TABLE KEY path = lv_path.
        IF sy-subrc <> 0. cv_error = '백업용 manifest 항목 누락'. RETURN. ENDIF.
        READ TABLE wa_targets INTO ls_target WITH KEY selected = 'X' file-path = lv_path.
        IF sy-subrc = 0.
* Restore package A=forward wanted B=pre-apply current. After a successful
* forward save, A matches SAP; failed/unattempted rows are already equal to B.
          lv_a = ls_target-wanted. lv_b = ls_target-before.
        ELSE.
          PERFORM wa_backup_payload USING lv_path CHANGING lv_a cv_error.
          IF cv_error IS NOT INITIAL. RETURN. ENDIF.
* W3MI's expected filesize must describe the forward content, not the old
* content. All other WWWPARAMS and the original API evidence are preserved.
          READ TABLE wa_targets INTO ls_target
            WITH KEY selected = 'X' asset-metadata_path = lv_path file-object = 'W3MI'.
          IF sy-subrc = 0.
            lt_params = ls_target-params. REFRESH lt_api.
            CALL TRANSFORMATION id SOURCE XML lv_a RESULT api_metadata = lt_api.
            lv_size = xstrlen( ls_target-wanted ).
            LOOP AT lt_params INTO ls_param.
              lv_name = ls_param-name. TRANSLATE lv_name TO LOWER CASE.
              IF lv_name = 'filesize'.
                WRITE lv_size TO ls_param-value LEFT-JUSTIFIED NO-GROUPING.
                CONDENSE ls_param-value. MODIFY lt_params FROM ls_param.
              ENDIF.
            ENDLOOP.
            CALL TRANSFORMATION id SOURCE object_name = ls_target-file-obj_name
              parameters = lt_params api_metadata = lt_api exact_byte_length = lv_size RESULT XML lv_a.
          ENDIF.
          lv_b = lv_a.
        ENDIF.
        ls_file-byte_length = xstrlen( lv_a ).
        CALL METHOD cl_abap_zip=>crc32 EXPORTING content = lv_a RECEIVING crc32 = ls_file-checksum.
        APPEND ls_file TO lt_files.
        PERFORM scope_zip_path USING ls_file-baseline CHANGING lv_zip_path.
        CALL METHOD lo_zip->add EXPORTING name = lv_zip_path content = lv_a.
        PERFORM scope_zip_path USING ls_file-path CHANGING lv_zip_path.
        CALL METHOD lo_zip->add EXPORTING name = lv_zip_path content = lv_b.
      ENDLOOP.
      ls_header = im_header. ls_header-completeness = 'PARTIAL'.
      CLEAR ls_header-import_enabled.
      CALL TRANSFORMATION id SOURCE header = ls_header packages = im_packages files = lt_files
        generated_by = 'DIAG 0.7.1 selected-asset rollback; source Export version retained'
        RESULT XML lv_meta.
      PERFORM scope_zip_path USING 'manifest.xml' CHANGING lv_zip_path.
        CALL METHOD lo_zip->add EXPORTING name = lv_zip_path content = lv_meta.
      lv_text = 'DIAG 0.7.1 rollback package. Only selected existing MIME/BSP Layout assets are write candidates.'.
      CONCATENATE lv_text 'Upload to DIAG with the same PACKAGE/BSP selection, BSP name and SID/client; choose Web assets.'
        'Content B is the verified pre-apply server data. Baseline A is the forward intended data.'
        'Unchanged or unattempted items require no write. Concurrent later changes remain blocked.'
        'Catalog identity comes from the original Export; this is a partial restore package, not a new Export.'
        'BSP restoration requires page activation. Resolve pending changes of the selected page/shared definition first.'
        INTO lv_text SEPARATED BY cl_abap_char_utilities=>newline.
      PERFORM utf8 USING lv_text CHANGING lv_meta.
      PERFORM scope_zip_path USING 'ROLLBACK_README.txt' CHANGING lv_zip_path.
        CALL METHOD lo_zip->add EXPORTING name = lv_zip_path content = lv_meta.
      cv_raw = lo_zip->save( ).
      IF xstrlen( cv_raw ) > gv_maxbytes. cv_error = '백업 ZIP이 업로드 제한을 초과합니다. 선택 파일 수를 줄이십시오.'. ENDIF.
    CATCH cx_root INTO lo_error. cv_error = lo_error->get_text( ).
  ENDTRY.
ENDFORM.

FORM wa_backup_save CHANGING cv_error TYPE string.
  DATA: lv_raw TYPE xstring, lv_file TYPE string, lv_path TYPE string,
        lv_full TYPE string, lv_action TYPE i, lv_run TYPE c LENGTH 12.
  CLEAR cv_error.
  PERFORM wa_backup_build CHANGING lv_raw cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  GET TIME. WRITE wa_run TO lv_run NO-GROUPING. CONDENSE lv_run.
  CONCATENATE 'DIAG_ROLLBACK_' sy-sysid '_' sy-mandt '_' sy-datum '_' sy-uzeit '_' lv_run '.zip' INTO lv_file.
  CALL METHOD cl_gui_frontend_services=>file_save_dialog
    EXPORTING window_title = '선택 웹자산 서버 원본 백업(원복 ZIP)' default_extension = 'zip'
      default_file_name = lv_file file_filter = 'ZIP (*.zip)|*.zip|'
    CHANGING filename = lv_file path = lv_path fullpath = lv_full user_action = lv_action
    EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0 OR lv_action <> 0 OR lv_full IS INITIAL.
    cv_error = '백업 취소: SAP 콘텐츠를 저장하지 않았습니다.'. RETURN.
  ENDIF.
  PERFORM wa_write_file USING lv_full lv_raw 'X' CHANGING cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  wa_backup = lv_full. CONCATENATE lv_full '.run.xml' INTO wa_journal.
  PERFORM wa_event_add USING 0 lv_full 'BACKUP' 'VERIFIED' lv_full.
  PERFORM wa_flush CHANGING cv_error.
ENDFORM.

FORM wa_one CHANGING cs_target TYPE wa_target cv_error TYPE string.
  DATA: lv_raw TYPE xstring, lv_check_error TYPE string, lv_detail TYPE string,
        lv_after TYPE i, lv_attempt TYPE c, lv_rc TYPE sysubrc,
        lo_error TYPE REF TO cx_root.
  CLEAR cv_error.
  IF cs_target-file-object = 'WAPA'.
    PERFORM wa_bsp_one CHANGING cs_target cv_error. RETURN.
  ENDIF.
  TRY.
      PERFORM wa_read USING space CHANGING cs_target lv_raw cv_error.
      IF cv_error IS INITIAL AND lv_raw <> cs_target-before.
        cv_error = '저장 직전 SAP 내용이 진단 시점과 다릅니다. 덮어쓰지 않았습니다.'.
      ENDIF.
      IF cv_error IS INITIAL.
        lv_detail = 'CTS 등록 및 저장 호출 직전. 중단된 경우 실제 SAP 재진단이 필요합니다.'.
        PERFORM wa_set_result USING cs_target-id 'WRITE_INTENT' lv_detail '@09@' 0 cs_target-task.
        PERFORM wa_event_add USING cs_target-id cs_target-file-path 'BEFORE_WRITE' 'WRITE_INTENT' lv_detail.
        PERFORM wa_flush CHANGING cv_error.
      ENDIF.
      IF cv_error IS INITIAL.
        lv_attempt = 'X'. wa_touched = 'X'.
        CLEAR: sy-msgid, sy-msgno, sy-msgv1, sy-msgv2, sy-msgv3, sy-msgv4.
        PERFORM wa_cts CHANGING cs_target cv_error.
      ENDIF.
      IF cv_error IS INITIAL. PERFORM wa_put USING cs_target CHANGING cv_error. ENDIF.
      IF cv_error IS INITIAL.
        COMMIT WORK AND WAIT.
        lv_rc = sy-subrc.
        IF lv_rc <> 0. cv_error = 'COMMIT update failure: 실제 저장 상태를 재진단하십시오.'. ENDIF.
      ELSEIF lv_attempt = 'X'.
        ROLLBACK WORK.
      ENDIF.
    CATCH cx_root INTO lo_error.
      cv_error = lo_error->get_text( ).
      IF lv_attempt = 'X'. ROLLBACK WORK. ENDIF.
  ENDTRY.
  IF lv_attempt = 'X'.
* An API may commit internally. ROLLBACK is never reported as a successful
* restoration. Re-read even after errors and retain the manual restore ZIP.
    CLEAR cs_target-eligible.
    PERFORM wa_read USING 'X' CHANGING cs_target lv_raw lv_check_error.
    IF lv_check_error IS INITIAL.
      lv_after = xstrlen( lv_raw ).
      IF lv_raw <> cs_target-wanted AND cv_error IS INITIAL.
        cv_error = '저장 후 전체 바이트가 업로드 파일과 다릅니다.'.
      ENDIF.
      IF cv_error IS NOT INITIAL.
        IF lv_raw = cs_target-before. lv_detail = '현재 조회 바이트는 저장 전과 동일.'.
        ELSEIF lv_raw = cs_target-wanted. lv_detail = '현재 조회 바이트는 업로드와 동일하나 이전 API 오류가 있어 성공 판정 보류.'.
        ELSE. lv_detail = '현재 SAP는 저장 전/업로드 모두와 다릅니다. 백업 기준으로 확인 필요.'. ENDIF.
        CONCATENATE cv_error lv_detail INTO cv_error SEPARATED BY space.
      ENDIF.
    ELSE.
      CONCATENATE cv_error '반영 후 조회 실패:' lv_check_error INTO cv_error SEPARATED BY space.
    ENDIF.
    IF cv_error IS INITIAL. PERFORM wa_cts_verify USING cs_target CHANGING cv_error. ENDIF.
  ENDIF.
  IF cv_error IS INITIAL AND lv_attempt = 'X'.
    lv_detail = 'MIME 저장·재조회 바이트 일치. 별도 활성화 없음. HTTP/캐시/화면 실행은 미검증.'.
    PERFORM wa_set_result USING cs_target-id 'SAVED_VERIFIED' lv_detail '@08@' lv_after cs_target-task.
    PERFORM wa_event_add USING cs_target-id cs_target-file-path 'READ_BACK' 'SAVED_VERIFIED' lv_detail.
  ELSE.
    PERFORM wa_set_result USING cs_target-id 'FAILED_REVIEW' cv_error '@0A@' lv_after cs_target-task.
    PERFORM wa_event_add USING cs_target-id cs_target-file-path 'APPLY' 'FAILED_REVIEW' cv_error.
  ENDIF.
  PERFORM wa_flush CHANGING lv_check_error.
  IF lv_check_error IS NOT INITIAL.
    wa_log_error = lv_check_error.
    CONCATENATE cv_error '실행 로그 저장 실패:' lv_check_error INTO cv_error SEPARATED BY space.
    PERFORM wa_set_result USING cs_target-id 'LOG_FAILED_REVIEW' cv_error '@0A@' lv_after cs_target-task.
  ENDIF.
ENDFORM.

FORM wa_apply USING po_grid TYPE REF TO cl_gui_alv_grid.
  DATA: lv_valid TYPE c, lt_hidden TYPE lvc_t_fidx, lv_index TYPE i,
        lv_count TYPE i, lv_n TYPE c LENGTH 12, lv_prompt TYPE c LENGTH 200,
        lv_answer TYPE c, lv_error TYPE string, lv_unlock_error TYPE string,
        lv_raw TYPE xstring, lv_detail TYPE string, lv_started TYPE c,
        lo_error TYPE REF TO cx_root, ls_target TYPE wa_target.
  FIELD-SYMBOLS: <ls_row> TYPE im_result, <ls_target> TYPE wa_target.
  IF p_mime <> 'X' OR im_screen_mode <> 'M' OR wa_busy = 'X'. RETURN. ENDIF.
  LOOP AT wa_targets INTO ls_target WHERE locked = 'X'.
    MESSAGE '이전 실행의 잠금 해제 실패가 있습니다. 로그 확인 후 이 프로그램 세션을 종료하십시오.' TYPE 'I'.
    RETURN.
  ENDLOOP.
  CALL METHOD po_grid->check_changed_data IMPORTING e_valid = lv_valid.
  IF lv_valid IS INITIAL. MESSAGE '선택 입력을 확인하십시오.' TYPE 'I'. RETURN. ENDIF.
  CALL METHOD po_grid->get_filtered_entries IMPORTING et_filtered_entries = lt_hidden.
  LOOP AT wa_targets ASSIGNING <ls_target>. CLEAR <ls_target>-selected. ENDLOOP.
  LOOP AT im_results ASSIGNING <ls_row> WHERE wa_sel = 'X'.
    lv_index = sy-tabix.
    READ TABLE lt_hidden WITH KEY table_line = lv_index TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      lv_error = 'ALV 필터로 숨겨진 선택 행이 있습니다. 필터를 해제하거나 해당 선택을 해제하십시오.'. EXIT.
    ENDIF.
    READ TABLE wa_targets ASSIGNING <ls_target> WITH KEY id = <ls_row>-id.
    IF sy-subrc <> 0.
      lv_error = '선택 행에 저장 불가 항목이 있습니다. 반영 상태/설명을 확인하십시오.'. EXIT.
    ENDIF.
    IF <ls_target>-eligible <> 'X'.
      lv_error = '이미 저장을 시도한 행입니다. 최신 상태로 다시 진단하십시오.'. EXIT.
    ENDIF.
    <ls_target>-selected = 'X'. ADD 1 TO lv_count.
  ENDLOOP.
  IF lv_error IS NOT INITIAL. MESSAGE lv_error TYPE 'I'. RETURN. ENDIF.
  IF lv_count = 0. MESSAGE '저장 후보 웹자산을 선택하십시오.' TYPE 'I'. RETURN. ENDIF.
  IF lv_count > 100.
    MESSAGE '한 번에 최대 100개 파일을 반영합니다. 선택 범위를 줄이십시오.' TYPE 'I'. RETURN.
  ENDIF.
  WRITE lv_count TO lv_n NO-GROUPING. CONDENSE lv_n.
  CONCATENATE '선택한' lv_n '건을 백업 후 저장/활성화합니다. 미활성본 재개 행은 저장을 생략합니다.'
    '중간 실패 시 앞서 성공한 파일은 유지됩니다. 계속하시겠습니까?'
    INTO lv_prompt SEPARATED BY space.
  CALL FUNCTION 'POPUP_TO_CONFIRM' EXPORTING titlebar = '웹자산 저장/활성화'
    text_question = lv_prompt text_button_1 = '반영 진행' text_button_2 = '취소'
    default_button = '2' display_cancel_button = 'X' IMPORTING answer = lv_answer EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0 OR lv_answer <> '1'. RETURN. ENDIF.
  wa_busy = 'X'. ADD 1 TO wa_run.
  CLEAR: wa_backup, wa_journal, wa_journal_owned, wa_log_error.
  TRY.
* Check every selected target before locking or mutating any repository.
      LOOP AT wa_targets ASSIGNING <ls_target> WHERE selected = 'X'.
        PERFORM wa_api_check USING <ls_target> CHANGING lv_error.
        IF lv_error IS INITIAL.
          PERFORM wa_read USING space CHANGING <ls_target> lv_raw lv_error.
        ENDIF.
        IF lv_error IS INITIAL AND lv_raw <> <ls_target>-before.
          lv_error = '진단 이후 SAP 내용이 변경되었습니다. 다시 진단하십시오.'.
        ENDIF.
        IF lv_error IS NOT INITIAL.
          PERFORM wa_set_result USING <ls_target>-id 'PREFLIGHT_FAILED' lv_error '@0A@' 0 <ls_target>-task.
          PERFORM wa_event_add USING <ls_target>-id <ls_target>-file-path 'PREFLIGHT' 'FAILED' lv_error.
          EXIT.
        ENDIF.
      ENDLOOP.
      IF lv_error IS INITIAL.
        LOOP AT wa_targets ASSIGNING <ls_target> WHERE selected = 'X'.
          PERFORM wa_lock USING 'X' CHANGING <ls_target> lv_error.
          IF lv_error IS INITIAL.
            PERFORM wa_read USING space CHANGING <ls_target> lv_raw lv_error.
          ENDIF.
          IF lv_error IS INITIAL AND lv_raw <> <ls_target>-before.
            lv_error = '잠금 후 SAP 내용이 진단 시점과 다릅니다.'.
          ENDIF.
          IF lv_error IS NOT INITIAL.
            PERFORM wa_set_result USING <ls_target>-id 'LOCK_CHECK_FAILED' lv_error '@0A@' 0 <ls_target>-task.
            PERFORM wa_event_add USING <ls_target>-id <ls_target>-file-path 'LOCK_READ' 'FAILED' lv_error.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.
      IF lv_error IS INITIAL. PERFORM wa_backup_save CHANGING lv_error. ENDIF.
      IF lv_error IS INITIAL.
        lv_started = 'X'.
        LOOP AT wa_targets ASSIGNING <ls_target> WHERE selected = 'X'.
          IF lv_error IS NOT INITIAL.
            lv_detail = '이전 파일 실패로 미실행. 앞서 성공한 파일은 자동 취소되지 않습니다.'.
            PERFORM wa_set_result USING <ls_target>-id 'NOT_RUN' lv_detail '@09@' 0 <ls_target>-task.
            PERFORM wa_event_add USING <ls_target>-id <ls_target>-file-path 'APPLY' 'NOT_RUN' lv_detail.
            CONTINUE.
          ENDIF.
          PERFORM wa_one CHANGING <ls_target> lv_error.
        ENDLOOP.
      ENDIF.
    CATCH cx_root INTO lo_error.
      lv_error = lo_error->get_text( ).
      ROLLBACK WORK.
      PERFORM wa_event_add USING 0 wa_backup 'UNEXPECTED' 'FAILED_REVIEW' lv_error.
  ENDTRY.
* All exits converge here. Only locks successfully acquired by this run
* are released; never DEQUEUE_ALL or a foreign/global unlock.
  LOOP AT wa_targets ASSIGNING <ls_target> WHERE locked = 'X'.
    PERFORM wa_lock USING space CHANGING <ls_target> lv_unlock_error.
    IF lv_unlock_error IS NOT INITIAL.
      PERFORM wa_event_add USING <ls_target>-id <ls_target>-file-path 'UNLOCK' 'FAILED' lv_unlock_error.
      CONCATENATE lv_error '잠금 해제 실패:' lv_unlock_error INTO lv_error SEPARATED BY space.
    ENDIF.
  ENDLOOP.
  LOOP AT im_results ASSIGNING <ls_row> WHERE wa_sel = 'X'.
    CLEAR <ls_row>-wa_sel.
    READ TABLE wa_targets INTO ls_target WITH KEY id = <ls_row>-id.
    IF sy-subrc = 0 AND ls_target-eligible IS INITIAL. CLEAR <ls_row>-wa_ready. ENDIF.
  ENDLOOP.
  IF wa_journal_owned = 'X'.
    PERFORM wa_flush CHANGING lv_unlock_error.
    IF lv_unlock_error IS NOT INITIAL.
      CONCATENATE lv_error '최종 로그 저장 실패:' lv_unlock_error INTO lv_error SEPARATED BY space.
    ENDIF.
  ENDIF.
  PERFORM wa_sync_results. CLEAR wa_busy.
  CALL METHOD po_grid->refresh_table_display EXCEPTIONS OTHERS = 1.
  IF lv_error IS NOT INITIAL. MESSAGE lv_error TYPE 'I'.
  ELSEIF lv_started = 'X'.
    MESSAGE '선택 웹자산 반영·재검증 완료. 저장/활성화 결과 확인 후 실제 화면을 시험하십시오.' TYPE 'S'.
  ENDIF.
ENDFORM.

FORM wa_fm_contract USING pv_fm TYPE rs38l-name pv_spec TYPE string
                    CHANGING cv_error TYPE string.
* Active target-system metadata is required before any write API is called.
* Specs contain declaration-side direction, name and optional exact DDIC type.
  DATA: lt_meta TYPE STANDARD TABLE OF fupararef, ls_meta TYPE fupararef,
        lt_specs TYPE ty_lines, lv_spec TYPE string, lv_kind TYPE string,
        lv_name TYPE string, lv_type TYPE string, lv_found TYPE c.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  SELECT * FROM fupararef INTO TABLE lt_meta WHERE funcname = pv_fm AND r3state = 'A'.
  IF lt_meta IS INITIAL.
    CONCATENATE 'API_NOT_FOUND' pv_fm INTO cv_error SEPARATED BY space. RETURN.
  ENDIF.
  SPLIT pv_spec AT space INTO TABLE lt_specs.
  LOOP AT lt_specs INTO lv_spec.
    CLEAR: lv_kind, lv_name, lv_type.
    SPLIT lv_spec AT ':' INTO lv_kind lv_name lv_type.
    READ TABLE lt_meta INTO ls_meta WITH KEY parameter = lv_name paramtype = lv_kind.
    IF sy-subrc <> 0 OR ( lv_type IS NOT INITIAL AND ls_meta-structure <> lv_type ).
      CONCATENATE 'API_SIGNATURE' pv_fm lv_spec INTO cv_error SEPARATED BY space. RETURN.
    ENDIF.
  ENDLOOP.
  LOOP AT lt_meta INTO ls_meta.
    IF ( ls_meta-paramtype = 'I' OR ls_meta-paramtype = 'C' OR ls_meta-paramtype = 'T' )
       AND ls_meta-optional IS INITIAL AND ls_meta-defaultval IS INITIAL.
      CLEAR lv_found.
      LOOP AT lt_specs INTO lv_spec.
        SPLIT lv_spec AT ':' INTO lv_kind lv_name lv_type.
        IF lv_name = ls_meta-parameter AND lv_kind = ls_meta-paramtype. lv_found = 'X'. ENDIF.
      ENDLOOP.
      IF lv_found IS INITIAL.
        CONCATENATE 'API_REQUIRED_PARAMETER' pv_fm ls_meta-parameter
          INTO cv_error SEPARATED BY space. RETURN.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.

FORM wa_api_check USING ps_target TYPE wa_target CHANGING cv_error TYPE string.
  DATA: lo_type TYPE REF TO cl_abap_typedescr,
        lo_descr TYPE REF TO cl_abap_objectdescr, ls_method TYPE abap_methdescr,
        ls_param TYPE abap_parmdescr, lt_names TYPE ty_lines, lv_name TYPE string,
        lv_names TYPE string, lv_found TYPE c, lo_error TYPE REF TO cx_root.
  CLEAR cv_error.
  IF ps_target-file-object = 'WAPA'.
    PERFORM wa_bsp_api_check CHANGING cv_error. RETURN.
  ENDIF.
  PERFORM wa_fm_contract USING 'RS_CORR_INSERT'
    'I:OBJECT I:OBJECT_CLASS I:DEVCLASS I:KORRNUM I:GLOBAL_LOCK I:SUPPRESS_DIALOG E:KORRNUM E:DEVCLASS'
    CHANGING cv_error.
  IF ps_target-file-object = 'SMIM'.
    PERFORM wa_fm_contract USING 'SDOK_LOIO_ENQUEUE' 'I:OBJECT_ID:SDOKOBJECT I:SCOPE'
      CHANGING cv_error.
    PERFORM wa_fm_contract USING 'SDOK_LOIO_DEQUEUE' 'I:OBJECT_ID:SDOKOBJECT I:SCOPE'
      CHANGING cv_error.
    IF cv_error IS NOT INITIAL. RETURN. ENDIF.
    TRY.
        CALL METHOD cl_abap_typedescr=>describe_by_name EXPORTING p_name = 'IF_MR_API'
          RECEIVING p_descr_ref = lo_type EXCEPTIONS OTHERS = 1.
        IF sy-subrc <> 0. cv_error = 'IF_MR_API RTTI unavailable'. RETURN. ENDIF.
        lo_descr ?= lo_type.
        READ TABLE lo_descr->methods INTO ls_method WITH KEY name = 'PUT'.
        IF sy-subrc <> 0 OR ls_method-is_class = 'X' OR
           ls_method-visibility <> cl_abap_objectdescr=>public.
          cv_error = 'IF_MR_API PUT public instance method unavailable'. RETURN.
        ENDIF.
        lv_names = 'I_URL I_CONTENT I_LANGUAGE I_DEV_PACKAGE I_CORR_NUMBER I_CHECK_AUTHORITY'.
        SPLIT lv_names AT space INTO TABLE lt_names.
        LOOP AT lt_names INTO lv_name.
          READ TABLE ls_method-parameters INTO ls_param WITH KEY name = lv_name.
          IF sy-subrc <> 0 OR ls_param-parm_kind <> cl_abap_objectdescr=>importing.
            CONCATENATE 'PUT parameter mismatch:' lv_name INTO cv_error SEPARATED BY space. RETURN.
          ENDIF.
        ENDLOOP.
        LOOP AT ls_method-parameters INTO ls_param.
          IF ls_param-is_optional IS INITIAL AND
             ( ls_param-parm_kind = cl_abap_objectdescr=>importing OR
               ls_param-parm_kind = cl_abap_objectdescr=>changing ).
            CLEAR lv_found.
            READ TABLE lt_names WITH KEY table_line = ls_param-name TRANSPORTING NO FIELDS.
            IF sy-subrc = 0. lv_found = 'X'. ENDIF.
            IF lv_found IS INITIAL.
              CONCATENATE 'PUT required parameter:' ls_param-name INTO cv_error SEPARATED BY space. RETURN.
            ENDIF.
          ENDIF.
        ENDLOOP.
      CATCH cx_root INTO lo_error. cv_error = lo_error->get_text( ).
    ENDTRY.
  ELSEIF ps_target-file-object = 'W3MI'.
    PERFORM wa_fm_contract USING 'ENQUEUE_E_WWW_HTML'
      'I:MODE_WWWDATA I:RELID I:OBJID I:SRTF2 I:_SCOPE' CHANGING cv_error.
    PERFORM wa_fm_contract USING 'DEQUEUE_E_WWW_HTML'
      'I:MODE_WWWDATA I:RELID I:OBJID I:SRTF2 I:_SCOPE' CHANGING cv_error.
    PERFORM wa_fm_contract USING 'WWWDATA_IMPORT' 'I:KEY:WWWDATATAB T:MIME:W3MIME' CHANGING cv_error.
    PERFORM wa_fm_contract USING 'WWWDATA_EXPORT' 'I:KEY:WWWDATATAB T:MIME:W3MIME' CHANGING cv_error.
    PERFORM wa_fm_contract USING 'WWWPARAMS_UPDATE' 'T:PARAMS:WWWPARAMS' CHANGING cv_error.
  ELSE.
    cv_error = 'WRITE_OBJECT_NOT_SUPPORTED'.
  ENDIF.
ENDFORM.

FORM wa_authority USING ps_target TYPE wa_target CHANGING cv_error TYPE string.
  DATA: ls_tadir TYPE tadir, ls_task TYPE e070, ls_order TYPE e070.
  CLEAR cv_error.
  SELECT SINGLE * FROM tadir INTO ls_tadir WHERE pgmid = 'R3TR'
    AND object = ps_target-file-object AND obj_name = ps_target-file-obj_name.
  IF sy-subrc <> 0 OR ls_tadir-devclass <> ps_target-file-devclass OR
     ls_tadir-delflag = 'X' OR ls_tadir-genflag = 'X'.
    cv_error = '기존 TADIR 객체/패키지가 변경되었거나 삭제·생성 관리 대상입니다.'. RETURN.
  ENDIF.
  AUTHORITY-CHECK OBJECT 'S_DEVELOP' ID 'DEVCLASS' FIELD ps_target-file-devclass
    ID 'OBJTYPE' FIELD ps_target-file-object ID 'OBJNAME' FIELD ps_target-file-obj_name
    ID 'P_GROUP' DUMMY ID 'ACTVT' FIELD '02'.
  IF sy-subrc <> 0. cv_error = 'S_DEVELOP 변경 권한이 없습니다.'. RETURN. ENDIF.
  IF ps_target-file-devclass = '$TMP'. RETURN. ENDIF.
  IF p_task IS INITIAL.
    cv_error = '운송 대상 파일: 내 수정 가능한 Workbench 작업 번호를 선택 화면에 입력하십시오.'. RETURN.
  ENDIF.
  SELECT SINGLE * FROM e070 INTO ls_task WHERE trkorr = p_task.
  IF sy-subrc <> 0 OR ls_task-trstatus <> 'D' OR ls_task-trfunction <> 'S' OR
     ls_task-as4user <> sy-uname OR ls_task-strkorr IS INITIAL.
    cv_error = 'CTS 번호는 현재 사용자 소유의 수정 가능한 개발 작업(S)이어야 합니다.'. RETURN.
  ENDIF.
  SELECT SINGLE * FROM e070 INTO ls_order WHERE trkorr = ls_task-strkorr.
  IF sy-subrc <> 0 OR ls_order-trstatus <> 'D' OR ls_order-trfunction <> 'K'.
    cv_error = 'CTS 상위 요청은 수정 가능한 Workbench 요청(K)이어야 합니다.'. RETURN.
  ENDIF.
ENDFORM.

FORM wa_api_error USING pv_phase TYPE csequence pv_rc TYPE sysubrc
                  CHANGING cv_error TYPE string.
  DATA: lv_rc TYPE c LENGTH 12, lv_message TYPE c LENGTH 255.
  WRITE pv_rc TO lv_rc NO-GROUPING. CONDENSE lv_rc.
  IF sy-msgid IS NOT INITIAL.
    MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO lv_message.
  ENDIF.
  CONCATENATE pv_phase 'RC=' lv_rc lv_message INTO cv_error SEPARATED BY space.
ENDFORM.

FORM wa_read USING pv_after TYPE c CHANGING cs_target TYPE wa_target
                                           cv_raw TYPE xstring cv_error TYPE string.
  DATA: lo_api TYPE REF TO if_mr_api, lv_url TYPE string, lv_folder TYPE boole_d,
        ls_io TYPE skwf_io, lv_lang TYPE langu, lv_lang2 TYPE langu,
        lv_mime TYPE string, lv_mime2 TYPE string, lv_again TYPE xstring,
        lv_phio TYPE sdok_phid, lv_phio2 TYPE sdok_phid,
        lt_params TYPE STANDARD TABLE OF wwwparams,
        lt_params2 TYPE STANDARD TABLE OF wwwparams,
        lt_expect TYPE STANDARD TABLE OF wwwparams, ls_param TYPE wwwparams,
        lt_mime TYPE STANDARD TABLE OF w3mime, lt_mime2 TYPE STANDARD TABLE OF w3mime,
        lv_size TYPE i, lv_size_text TYPE string, lv_ok TYPE c, lv_name TYPE string,
        lv_ext TYPE string, lv_type TYPE string, lv_count TYPE i,
        lv_fm TYPE rs38l-name, lv_rc TYPE sysubrc, lo_error TYPE REF TO cx_root.
  CLEAR: cv_raw, cv_error.
  PERFORM wa_scope_check USING cs_target CHANGING cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  IF cs_target-file-object = 'WAPA'.
    PERFORM wa_bsp_read USING pv_after CHANGING cs_target cv_raw cv_error. RETURN.
  ENDIF.
  PERFORM wa_authority USING cs_target CHANGING cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  TRY.
      IF cs_target-file-object = 'SMIM'.
        lo_api = cl_mime_repository_api=>get_api( ).
        IF lo_api IS INITIAL. cv_error = 'MIME API unavailable'. RETURN. ENDIF.
        CALL METHOD lo_api->get_url_for_io EXPORTING i_loio = cs_target-meta-loio
          IMPORTING e_url = lv_url e_is_folder = lv_folder EXCEPTIONS OTHERS = 1.
        IF sy-subrc <> 0 OR lv_folder = 'X' OR lv_url <> cs_target-meta-url.
          cv_error = 'SMIM LOIO 경로 변경/조회 실패'. RETURN.
        ENDIF.
        CALL METHOD lo_api->get_io_for_url EXPORTING i_url = lv_url
          IMPORTING e_loio = ls_io e_is_folder = lv_folder EXCEPTIONS OTHERS = 1.
        IF sy-subrc <> 0 OR lv_folder = 'X' OR ls_io-objid <> cs_target-meta-loio OR ls_io-class IS INITIAL.
          cv_error = 'SMIM URL에서 역조회한 LOIO 불일치'. RETURN.
        ENDIF.
        IF cs_target-locked = 'X' AND
           ( cs_target-io-objid <> ls_io-objid OR cs_target-io-class <> ls_io-class ).
          cv_error = '잠근 LOIO와 현재 IO 식별자가 다릅니다.'. RETURN.
        ENDIF.
        cs_target-io-objid = ls_io-objid. cs_target-io-class = ls_io-class.
        lv_lang = cs_target-meta-actual_language. lv_lang2 = lv_lang.
        CALL METHOD lo_api->get_by_io EXPORTING i_loio = cs_target-meta-loio i_check_authority = 'X'
          IMPORTING e_content = cv_raw e_mime_type = lv_mime e_is_folder = lv_folder e_phio_id = lv_phio
          CHANGING c_language = lv_lang EXCEPTIONS OTHERS = 1.
        IF sy-subrc <> 0 OR lv_folder = 'X' OR lv_phio IS INITIAL.
          cv_error = 'SMIM GET_BY_IO 실패'. RETURN.
        ENDIF.
        CALL METHOD lo_api->get_by_io EXPORTING i_loio = cs_target-meta-loio i_check_authority = 'X'
          IMPORTING e_content = lv_again e_mime_type = lv_mime2 e_is_folder = lv_folder e_phio_id = lv_phio2
          CHANGING c_language = lv_lang2 EXCEPTIONS OTHERS = 1.
        IF sy-subrc <> 0 OR lv_folder = 'X' OR cv_raw <> lv_again OR lv_phio <> lv_phio2 OR
           lv_lang <> cs_target-meta-actual_language OR lv_lang <> lv_lang2 OR
           lv_mime <> cs_target-meta-mime_type OR lv_mime <> lv_mime2.
          cv_error = 'SMIM 반복 조회의 바이트·언어·PHIO·MIME 불일치'. RETURN.
        ENDIF.
        IF pv_after IS INITIAL AND lv_phio <> cs_target-phio.
          cv_error = '진단 이후 PHIO가 변경되었습니다. 다시 진단하십시오.'. RETURN.
        ENDIF.
* Also use the URL-facing repository reader. This is not an HTTP/cache test.
        CLEAR: ls_io, lv_again. lv_lang2 = cs_target-meta-actual_language.
        CALL METHOD lo_api->get EXPORTING i_url = lv_url i_check_authority = 'X'
          IMPORTING e_content = lv_again e_loio = ls_io e_mime_type = lv_mime2 e_is_folder = lv_folder
          CHANGING c_language = lv_lang2 EXCEPTIONS OTHERS = 1.
        IF sy-subrc <> 0 OR cv_raw <> lv_again OR ls_io-objid <> cs_target-meta-loio OR
           lv_lang2 <> cs_target-meta-actual_language OR lv_mime2 <> lv_mime OR lv_folder = 'X'.
          cv_error = 'SMIM URL 읽기와 LOIO 읽기가 일치하지 않습니다.'. RETURN.
        ENDIF.
      ELSEIF cs_target-file-object = 'W3MI'.
        SELECT SINGLE * FROM wwwdata INTO CORRESPONDING FIELDS OF cs_target-wwwkey
          WHERE relid = 'MI' AND objid = cs_target-file-obj_name AND srtf2 = 0.
        IF sy-subrc <> 0. cv_error = '기존 W3MI 헤더를 읽지 못했습니다.'. RETURN. ENDIF.
        SELECT * FROM wwwparams INTO TABLE lt_params
          WHERE relid = 'MI' AND objid = cs_target-file-obj_name.
        SORT lt_params BY relid objid name. lt_expect = cs_target-params.
        LOOP AT lt_params INTO ls_param.
          lv_type = ls_param-name. TRANSLATE lv_type TO LOWER CASE.
          CASE lv_type.
            WHEN 'filesize'. ADD 1 TO lv_count. lv_size_text = ls_param-value.
            WHEN 'filename'. lv_name = ls_param-value.
            WHEN 'fileextension'. lv_ext = ls_param-value.
            WHEN 'mimetype'. lv_mime = ls_param-value.
          ENDCASE.
        ENDLOOP.
        CONDENSE lv_size_text.
        IF lv_count <> 1 OR lv_size_text IS INITIAL OR lv_size_text CN '0123456789' OR strlen( lv_size_text ) > 8.
          cv_error = 'W3MI filesize 메타데이터가 유일하고 정확하지 않습니다.'. RETURN.
        ENDIF.
        lv_size = lv_size_text.
        IF lv_size > 16777216. cv_error = 'W3MI 16 MiB 제한 초과'. RETURN. ENDIF.
        IF pv_after = 'X'.
          LOOP AT lt_expect INTO ls_param.
            lv_type = ls_param-name. TRANSLATE lv_type TO LOWER CASE.
            IF lv_type = 'filesize'.
              WRITE lv_size TO ls_param-value LEFT-JUSTIFIED NO-GROUPING.
              CONDENSE ls_param-value. MODIFY lt_expect FROM ls_param.
            ENDIF.
          ENDLOOP.
        ENDIF.
        IF lt_expect <> lt_params.
          cv_error = 'W3MI 매개변수가 원본/예상 매개변수와 다릅니다.'. RETURN.
        ENDIF.
        IF lv_name IS INITIAL. lv_name = cs_target-file-obj_name. ENDIF.
        IF lv_name NS '.'.
          IF lv_ext IS INITIAL. lv_ext = '.bin'.
          ELSEIF lv_ext(1) <> '.'. CONCATENATE '.' lv_ext INTO lv_ext. ENDIF.
          CONCATENATE lv_name lv_ext INTO lv_name.
        ENDIF.
        IF lv_name <> cs_target-asset-original_path OR lv_mime <> cs_target-asset-mime_type.
          cv_error = 'W3MI 파일명/MIME 유형 불일치'. RETURN.
        ENDIF.
        lv_fm = 'WWWDATA_IMPORT'.
        CALL FUNCTION lv_fm EXPORTING key = cs_target-wwwkey TABLES mime = lt_mime
          EXCEPTIONS error_message = 1 OTHERS = 2.
        lv_rc = sy-subrc.
        IF lv_rc <> 0. PERFORM wa_api_error USING lv_fm lv_rc CHANGING cv_error. RETURN. ENDIF.
        CALL FUNCTION lv_fm EXPORTING key = cs_target-wwwkey TABLES mime = lt_mime2
          EXCEPTIONS error_message = 1 OTHERS = 2.
        IF sy-subrc <> 0 OR lt_mime <> lt_mime2.
          cv_error = 'W3MI 반복 조회 불일치'. RETURN.
        ENDIF.
        SELECT * FROM wwwparams INTO TABLE lt_params2 WHERE relid = 'MI' AND objid = cs_target-file-obj_name.
        SORT lt_params2 BY relid objid name.
        IF lt_params <> lt_params2. cv_error = 'W3MI 조회 중 매개변수 변경'. RETURN. ENDIF.
        PERFORM web_binary USING lt_mime lv_size CHANGING cv_raw lv_ok.
        IF lv_ok <> 'X'. cv_error = 'W3MI 실제 길이로 원본 바이트 복원 실패'. RETURN. ENDIF.
      ELSE.
        cv_error = '읽기/쓰기 대상 유형 불일치'.
      ENDIF.
    CATCH cx_root INTO lo_error. cv_error = lo_error->get_text( ).
  ENDTRY.
ENDFORM.

FORM wa_lock USING pv_lock TYPE c CHANGING cs_target TYPE wa_target cv_error TYPE string.
  DATA: lv_fm TYPE rs38l-name, lv_rc TYPE sysubrc, lo_error TYPE REF TO cx_root.
  CLEAR cv_error.
  IF pv_lock IS INITIAL AND cs_target-locked IS INITIAL. RETURN. ENDIF.
  IF cs_target-file-object = 'WAPA'.
    PERFORM wa_bsp_lock USING pv_lock CHANGING cs_target cv_error. RETURN.
  ENDIF.
  TRY.
      CLEAR: sy-msgid, sy-msgno, sy-msgv1, sy-msgv2, sy-msgv3, sy-msgv4.
      IF cs_target-file-object = 'SMIM'.
        IF cs_target-io-class IS INITIAL OR cs_target-io-objid IS INITIAL.
          cv_error = '잠금 IO 식별자 없음'. RETURN.
        ENDIF.
        lv_fm = 'SDOK_LOIO_DEQUEUE'.
        IF pv_lock = 'X'. lv_fm = 'SDOK_LOIO_ENQUEUE'. ENDIF.
        CALL FUNCTION lv_fm EXPORTING object_id = cs_target-io scope = '1'
          EXCEPTIONS error_message = 1 OTHERS = 2.
      ELSEIF cs_target-file-object = 'W3MI'.
        lv_fm = 'DEQUEUE_E_WWW_HTML'.
        IF pv_lock = 'X'. lv_fm = 'ENQUEUE_E_WWW_HTML'. ENDIF.
        CALL FUNCTION lv_fm EXPORTING mode_wwwdata = 'E' relid = 'MI'
          objid = cs_target-wwwkey-objid srtf2 = 0 _scope = '1'
          EXCEPTIONS error_message = 1 OTHERS = 2.
      ELSE. cv_error = 'LOCK_OBJECT_NOT_SUPPORTED'. RETURN.
      ENDIF.
      lv_rc = sy-subrc.
      IF lv_rc <> 0. PERFORM wa_api_error USING lv_fm lv_rc CHANGING cv_error.
      ELSE. cs_target-locked = pv_lock. ENDIF.
    CATCH cx_root INTO lo_error. cv_error = lo_error->get_text( ).
  ENDTRY.
ENDFORM.

* ---------------- BSP Layout and reliable toolbar, DIAG 0.7.1 --------
FORM wa_top_free.
  IF wa_top_bar IS NOT INITIAL.
    SET HANDLER lcl_im_alv_fit=>top_command FOR wa_top_bar ACTIVATION space.
    CALL METHOD wa_top_bar->free EXCEPTIONS OTHERS = 1.
    FREE wa_top_bar.
  ENDIF.
  IF wa_top_dock IS NOT INITIAL.
    CALL METHOD wa_top_dock->free EXCEPTIONS OTHERS = 1.
    FREE wa_top_dock.
  ENDIF.
  CLEAR: wa_top_mode, wa_top_failed.
ENDFORM.

FORM wa_top_error.
  PERFORM wa_top_free. wa_top_failed = 'X'.
  MESSAGE '작업 버튼 바 생성 실패: SAP GUI for Windows에서 다시 실행하십시오.' TYPE 'I'.
ENDFORM.

FORM wa_top_show.
  DATA: lt_buttons TYPE ttb_button, ls_button TYPE stb_button,
        lt_events TYPE cntl_simple_events, ls_event TYPE cntl_simple_event,
        ls_link TYPE im_function_link.
  IF wa_top_failed = 'X'. RETURN. ENDIF.
  IF wa_top_bar IS NOT INITIAL AND wa_top_mode = im_screen_mode. RETURN. ENDIF.
  PERFORM wa_top_free.
  IF im_screen_mode = 'M'.
    IF p_mime = 'X'.
      ls_button-function = 'ZSAVE'. ls_button-text = '선택 저장/활성화'.
      ls_button-quickinfo = '선택 MIME 저장 또는 BSP Layout 저장·페이지 활성화'.
      APPEND ls_button TO lt_buttons. CLEAR ls_button.
      ls_button-function = 'ZWA_LOG'. ls_button-text = '반영 로그 저장'.
      APPEND ls_button TO lt_buttons. CLEAR ls_button.
    ENDIF.
    ls_button-function = 'ZJSON'. ls_button-text = 'JSON 다운로드'.
    APPEND ls_button TO lt_buttons.
  ELSEIF im_screen_mode = 'D'.
    PERFORM im_link_get USING im_view_result-path CHANGING ls_link.
    IF ls_link-api_path IS INITIAL. RETURN. ENDIF.
    ls_button-function = 'ZPROOF'. ls_button-text = '활성 소스 대조'.
    APPEND ls_button TO lt_buttons.
  ELSE. RETURN.
  ENDIF.
* A dedicated docking toolbar works with STANDARD_FULLSCREEN without
* installing a custom GUI status or relying on the hidden grid toolbar.
  CREATE OBJECT wa_top_dock
    EXPORTING side = cl_gui_docking_container=>dock_at_top
      extension = 40 metric = cl_gui_control=>metric_pixel
    EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0. PERFORM wa_top_error. RETURN. ENDIF.
  CREATE OBJECT wa_top_bar EXPORTING parent = wa_top_dock EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0. PERFORM wa_top_error. RETURN. ENDIF.
  CALL METHOD wa_top_bar->add_button_group EXPORTING data_table = lt_buttons
    EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0. PERFORM wa_top_error. RETURN. ENDIF.
  ls_event-eventid = cl_gui_toolbar=>m_id_function_selected.
  ls_event-appl_event = space. APPEND ls_event TO lt_events.
  CALL METHOD wa_top_bar->set_registered_events EXPORTING events = lt_events
    EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0. PERFORM wa_top_error. RETURN. ENDIF.
  SET HANDLER lcl_im_alv_fit=>top_command FOR wa_top_bar.
  wa_top_mode = im_screen_mode.
  CALL METHOD cl_gui_cfw=>flush EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0. PERFORM wa_top_error. ENDIF.
ENDFORM.

FORM wa_bsp_normalize USING pv_raw TYPE xstring
                     CHANGING cv_text TYPE string cv_error TYPE string.
  DATA: lv_cr TYPE c, lv_n TYPE i.
  PERFORM im_decode USING pv_raw CHANGING cv_text cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf IN cv_text
    WITH cl_abap_char_utilities=>newline.
  lv_cr = cl_abap_char_utilities=>cr_lf(1).
  IF cv_text CS lv_cr.
    cv_error = 'BSP Layout contains a lone CR; use UTF-8 with LF or CRLF'. RETURN.
  ENDIF.
* SET_PAGE uses logical lines. Ignore only one terminal newline. Interior
* whitespace, trailing spaces and extra empty lines remain significant.
  lv_n = strlen( cv_text ) - 1.
  IF lv_n >= 0.
    IF cv_text+lv_n(1) = cl_abap_char_utilities=>newline.
      cv_text = cv_text(lv_n).
    ENDIF.
  ENDIF.
ENDFORM.

FORM wa_bsp_equal USING pv_left TYPE xstring pv_right TYPE xstring
                 CHANGING cv_equal TYPE c cv_error TYPE string.
  DATA: lv_left TYPE string, lv_right TYPE string.
  CLEAR cv_equal.
  PERFORM wa_bsp_normalize USING pv_left CHANGING lv_left cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  PERFORM wa_bsp_normalize USING pv_right CHANGING lv_right cv_error.
  IF cv_error IS INITIAL AND lv_left = lv_right. cv_equal = 'X'. ENDIF.
ENDFORM.

FORM wa_bsp_row_text USING ps_row TYPE ANY
                    CHANGING cv_text TYPE string cv_error TYPE string.
  DATA: lv_kind TYPE c, lv_empty TYPE string.
  FIELD-SYMBOLS: <lv_cell> TYPE ANY, <lv_second> TYPE ANY.
  CLEAR: cv_text, cv_error.
  DESCRIBE FIELD ps_row TYPE lv_kind.
  IF lv_kind = 'u' OR lv_kind = 'v'.
    ASSIGN COMPONENT 1 OF STRUCTURE ps_row TO <lv_cell>.
    IF sy-subrc <> 0. cv_error = 'BSP readback row has no text field'. RETURN. ENDIF.
    ASSIGN COMPONENT 2 OF STRUCTURE ps_row TO <lv_second>.
    IF sy-subrc = 0. cv_error = 'BSP readback row has multiple fields'. RETURN. ENDIF.
  ELSE. ASSIGN ps_row TO <lv_cell>.
  ENDIF.
  DESCRIBE FIELD <lv_cell> TYPE lv_kind.
  IF lv_kind <> 'C' AND lv_kind <> 'g'.
    cv_error = 'BSP readback row is not text'. RETURN.
  ENDIF.
* Keep the entire field, including fixed-field padding. Never trim source.
  CONCATENATE <lv_cell> lv_empty INTO cv_text RESPECTING BLANKS.
ENDFORM.

FORM wa_bsp_compare_lines USING pt_expected TYPE o2pageline_table
                               pt_actual TYPE o2pageline_table
                         CHANGING cv_equal TYPE c cv_detail TYPE string.
  DATA: lv_expected TYPE i, lv_actual TYPE i, lv_rows TYPE i, lv_row TYPE i,
        lv_col TYPE i, lv_limit TYPE i, lv_left_n TYPE i, lv_right_n TYPE i,
        lv_left TYPE string, lv_right TYPE string, lv_error TYPE string,
        lv_left_char TYPE string, lv_right_char TYPE string,
        lv_en TYPE c LENGTH 12, lv_an TYPE c LENGTH 12,
        lv_rn TYPE c LENGTH 12, lv_cn TYPE c LENGTH 12,
        lv_ln TYPE c LENGTH 12, lv_rln TYPE c LENGTH 12.
  FIELD-SYMBOLS: <ls_left> TYPE ANY, <ls_right> TYPE ANY.
  CLEAR: cv_equal, cv_detail.
  DESCRIBE TABLE pt_expected LINES lv_expected.
  DESCRIBE TABLE pt_actual LINES lv_actual.
  WRITE lv_expected TO lv_en NO-GROUPING. CONDENSE lv_en.
  WRITE lv_actual TO lv_an NO-GROUPING. CONDENSE lv_an.
  CONCATENATE 'P_CONTENT 행 수 기대=' lv_en '/조회=' lv_an INTO cv_detail.
* Compare the exact SET_PAGE input with GET_PAGE output of the same DDIC type.
* No XML serialization, newline trimming, whitespace folding or row merging.
  IF pt_expected = pt_actual AND lv_expected > 0.
    cv_equal = 'X'. CONCATENATE cv_detail '; 모든 행 일치' INTO cv_detail. RETURN.
  ENDIF.
  IF lv_expected = 0.
    CONCATENATE cv_detail '; 기대 Layout 행 없음' INTO cv_detail. RETURN.
  ENDIF.
  lv_rows = lv_expected.
  IF lv_actual < lv_rows. lv_rows = lv_actual. ENDIF.
  DO lv_rows TIMES.
    lv_row = sy-index.
    READ TABLE pt_expected ASSIGNING <ls_left> INDEX lv_row.
    READ TABLE pt_actual ASSIGNING <ls_right> INDEX lv_row.
    PERFORM wa_bsp_row_text USING <ls_left> CHANGING lv_left lv_error.
    IF lv_error IS NOT INITIAL. cv_detail = lv_error. RETURN. ENDIF.
    PERFORM wa_bsp_row_text USING <ls_right> CHANGING lv_right lv_error.
    IF lv_error IS NOT INITIAL. cv_detail = lv_error. RETURN. ENDIF.
    IF lv_left = lv_right. CONTINUE. ENDIF.
    lv_left_n = strlen( lv_left ). lv_right_n = strlen( lv_right ).
    lv_limit = lv_left_n.
    IF lv_right_n < lv_limit. lv_limit = lv_right_n. ENDIF.
    CLEAR lv_col.
    WHILE lv_col < lv_limit.
      IF lv_left+lv_col(1) <> lv_right+lv_col(1). EXIT. ENDIF.
      ADD 1 TO lv_col.
    ENDWHILE.
    lv_left_char = '<EOL>'. lv_right_char = '<EOL>'.
    IF lv_col < lv_left_n. lv_left_char = lv_left+lv_col(1). ENDIF.
    IF lv_col < lv_right_n. lv_right_char = lv_right+lv_col(1). ENDIF.
    IF lv_left_char = space. lv_left_char = '<SPACE>'. ENDIF.
    IF lv_right_char = space. lv_right_char = '<SPACE>'. ENDIF.
    IF lv_left_char = cl_abap_char_utilities=>horizontal_tab. lv_left_char = '<TAB>'. ENDIF.
    IF lv_right_char = cl_abap_char_utilities=>horizontal_tab. lv_right_char = '<TAB>'. ENDIF.
    IF lv_left_char = cl_abap_char_utilities=>newline. lv_left_char = '<LF>'. ENDIF.
    IF lv_right_char = cl_abap_char_utilities=>newline. lv_right_char = '<LF>'. ENDIF.
    ADD 1 TO lv_col.
    WRITE lv_row TO lv_rn NO-GROUPING. CONDENSE lv_rn.
    WRITE lv_col TO lv_cn NO-GROUPING. CONDENSE lv_cn.
    WRITE lv_left_n TO lv_ln NO-GROUPING. CONDENSE lv_ln.
    WRITE lv_right_n TO lv_rln NO-GROUPING. CONDENSE lv_rln.
    CONCATENATE cv_detail '; 최초 차이 행=' lv_rn '/열=' lv_cn
      '; 행 문자수 기대=' lv_ln '/조회=' lv_rln INTO cv_detail.
    CONCATENATE cv_detail '; 차이 문자 기대=[' lv_left_char ']/조회=[' lv_right_char ']'
      INTO cv_detail RESPECTING BLANKS.
    RETURN.
  ENDDO.
  lv_row = lv_rows + 1. WRITE lv_row TO lv_rn NO-GROUPING. CONDENSE lv_rn.
  CONCATENATE cv_detail '; 최초 누락/추가 행=' lv_rn INTO cv_detail.
ENDFORM.

FORM wa_bsp_verify_record USING ps_target TYPE wa_target pv_phase TYPE csequence
                               pv_state TYPE csequence pv_detail TYPE string.
  FIELD-SYMBOLS <ls_row> TYPE im_result.
  READ TABLE im_results ASSIGNING <ls_row> WITH KEY id = ps_target-id.
  IF sy-subrc = 0.
    IF <ls_row>-wa_verify_detail IS INITIAL.
      CONCATENATE pv_phase ':' pv_detail INTO <ls_row>-wa_verify_detail.
    ELSE.
      CONCATENATE <ls_row>-wa_verify_detail cl_abap_char_utilities=>newline
        pv_phase ':' pv_detail INTO <ls_row>-wa_verify_detail RESPECTING BLANKS.
    ENDIF.
  ENDIF.
  PERFORM wa_event_add USING ps_target-id ps_target-file-path pv_phase pv_state pv_detail.
ENDFORM.

FORM wa_bsp_check_layout USING ps_target TYPE wa_target ps_now TYPE wa_bsp_snapshot
                              pv_phase TYPE csequence
                        CHANGING cv_equal TYPE c cv_error TYPE string.
  DATA: lv_detail TYPE string, lv_raw_equal TYPE c, lv_raw_error TYPE string,
        lv_raw_state TYPE c LENGTH 12, lv_state TYPE c LENGTH 12,
        lv_expected TYPE i, lv_actual TYPE i,
        lv_en TYPE c LENGTH 12, lv_an TYPE c LENGTH 12.
  CLEAR: cv_equal, cv_error.
  PERFORM wa_bsp_compare_lines USING ps_target-bsp_expected ps_now-content
    CHANGING cv_equal lv_detail.
  IF cv_equal = 'X'. lv_state = 'MATCH'.
  ELSE.
    lv_state = 'MISMATCH'.
    CONCATENATE pv_phase 'Layout 불일치:' lv_detail INTO cv_error SEPARATED BY space.
  ENDIF.
* P_XML_SOURCE/fallback bytes remain evidence; they are not the SET_PAGE contract.
  PERFORM wa_bsp_equal USING ps_now-layout ps_target-wanted
    CHANGING lv_raw_equal lv_raw_error.
  IF lv_raw_error IS NOT INITIAL. lv_raw_state = 'UNREADABLE'.
  ELSEIF lv_raw_equal = 'X'. lv_raw_state = 'MATCH'.
  ELSE. lv_raw_state = 'DIFFERENT'. ENDIF.
  lv_expected = xstrlen( ps_target-wanted ). lv_actual = xstrlen( ps_now-layout ).
  WRITE lv_expected TO lv_en NO-GROUPING. CONDENSE lv_en.
  WRITE lv_actual TO lv_an NO-GROUPING. CONDENSE lv_an.
  CONCATENATE lv_detail '; 원시 Layout 비교=' lv_raw_state
    '; 원시 바이트 업로드=' lv_en '/조회=' lv_an INTO lv_detail.
  IF lv_raw_error IS NOT INITIAL.
    CONCATENATE lv_detail '; 원시 해석:' lv_raw_error INTO lv_detail.
  ENDIF.
  PERFORM wa_bsp_verify_record USING ps_target pv_phase lv_state lv_detail.
ENDFORM.

FORM wa_bsp_tokens USING pv_text TYPE string
                  CHANGING ct_tokens TYPE ty_lines cv_error TYPE string.
  DATA: lv_rest TYPE string, lv_token TYPE string, lv_upper TYPE string,
        lv_at TYPE i, lv_end TYPE i, lv_len TYPE i.
  REFRESH ct_tokens. CLEAR cv_error. lv_rest = pv_text.
  lv_upper = pv_text. TRANSLATE lv_upper TO UPPER CASE.
* Conservative initial scope: runat=server script syntax is not parsed by
* this guard. Do not claim this lexical preservation check is a sandbox.
  IF lv_upper CS 'RUNAT'.
    cv_error = 'BSP RUNAT 구문은 이번 Layout 반영 범위에서 제외합니다.'. RETURN.
  ENDIF.
  WHILE lv_rest IS NOT INITIAL.
    FIND FIRST OCCURRENCE OF '<%' IN lv_rest MATCH OFFSET lv_at.
    IF sy-subrc <> 0. EXIT. ENDIF.
    lv_rest = lv_rest+lv_at.
    IF lv_rest CP '<%--*'.
      FIND FIRST OCCURRENCE OF '--%>' IN lv_rest MATCH OFFSET lv_end.
      lv_len = lv_end + 4.
    ELSE.
      FIND FIRST OCCURRENCE OF '%>' IN lv_rest MATCH OFFSET lv_end.
      lv_len = lv_end + 2.
    ENDIF.
    IF sy-subrc <> 0.
      cv_error = '닫히지 않은 BSP 서버 측 구문(<% ... %>)이 있습니다.'. RETURN.
    ENDIF.
    lv_token = lv_rest(lv_len). APPEND lv_token TO ct_tokens.
    lv_rest = lv_rest+lv_len.
  ENDWHILE.
ENDFORM.

FORM wa_bsp_line_error USING pv_reason TYPE csequence pv_row TYPE i
                                   pv_length TYPE i pv_capacity TYPE i
                             CHANGING cv_error TYPE string.
  DATA: lv_row TYPE c LENGTH 12, lv_length TYPE c LENGTH 12,
        lv_capacity TYPE c LENGTH 12.
  WRITE pv_row TO lv_row NO-GROUPING. CONDENSE lv_row.
  WRITE pv_length TO lv_length NO-GROUPING. CONDENSE lv_length.
  WRITE pv_capacity TO lv_capacity NO-GROUPING. CONDENSE lv_capacity.
  CONCATENATE 'BSP Layout 행' lv_row pv_reason ': 입력' lv_length
    '/ SAP 행 용량' lv_capacity '(문자 단위)' INTO cv_error SEPARATED BY space.
ENDFORM.

FORM wa_bsp_line_assign USING pv_text TYPE string pv_row TYPE i
                       CHANGING cv_cell TYPE ANY cv_round TYPE string cv_error TYPE string.
  DATA: lv_kind TYPE c, lv_length TYPE i, lv_capacity TYPE i,
        lv_padded TYPE string, lv_empty TYPE string.
  CLEAR: cv_round, cv_error.
  lv_length = strlen( pv_text ).
  DESCRIBE FIELD cv_cell TYPE lv_kind.
  IF lv_kind <> 'g' AND lv_kind <> 'C'.
    PERFORM wa_bsp_line_error USING '지원하지 않는 행 필드 유형' pv_row lv_length 0
      CHANGING cv_error. RETURN.
  ENDIF.
  IF lv_kind = 'C'.
    DESCRIBE FIELD cv_cell LENGTH lv_capacity IN CHARACTER MODE.
* Check before assignment: truncation must never be mistaken for padding.
    IF lv_length > lv_capacity.
      PERFORM wa_bsp_line_error USING '실제 길이 초과' pv_row lv_length lv_capacity
        CHANGING cv_error. RETURN.
    ENDIF.
  ENDIF.
  cv_cell = pv_text.
  CONCATENATE cv_cell lv_empty INTO lv_padded RESPECTING BLANKS.
  IF lv_kind = 'C'.
* Preserve exactly the known input extent, including input trailing spaces.
* Only the additional fixed-field padding may be ignored; never trim source.
    IF strlen( lv_padded ) <> lv_capacity.
      PERFORM wa_bsp_line_error USING '행 필드 길이 재확인 실패' pv_row lv_length lv_capacity
        CHANGING cv_error. RETURN.
    ENDIF.
    IF lv_length < lv_capacity AND lv_padded+lv_length CN space.
      PERFORM wa_bsp_line_error USING '원문 뒤에 공백 외 데이터 발생' pv_row lv_length lv_capacity
        CHANGING cv_error. RETURN.
    ENDIF.
    IF lv_length > 0. cv_round = lv_padded(lv_length). ENDIF.
  ELSE. cv_round = lv_padded.
  ENDIF.
  IF cv_round <> pv_text.
    PERFORM wa_bsp_line_error USING '문자 변환 불일치' pv_row lv_length lv_capacity
      CHANGING cv_error.
  ENDIF.
ENDFORM.

FORM wa_bsp_content USING pv_before TYPE xstring pv_wanted TYPE xstring
                   CHANGING ct_content TYPE o2pageline_table cv_error TYPE string.
  DATA: lv_before TYPE string, lv_wanted TYPE string, lv_again TYPE string,
        lt_before TYPE ty_lines, lt_wanted TYPE ty_lines, lt_lines TYPE ty_lines,
        lt_content TYPE o2pageline_table, lv_line TYPE string, lv_round TYPE string,
        lv_kind TYPE c, lv_row TYPE i, lv_length TYPE i, lv_split TYPE string.
  FIELD-SYMBOLS: <ls_line> TYPE ANY, <lv_cell> TYPE ANY, <lv_second> TYPE ANY.
  REFRESH ct_content.
  PERFORM wa_bsp_normalize USING pv_before CHANGING lv_before cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  PERFORM wa_bsp_normalize USING pv_wanted CHANGING lv_wanted cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  IF lv_wanted IS INITIAL. cv_error = '빈 BSP Layout으로 교체하지 않습니다.'. RETURN. ENDIF.
  PERFORM wa_bsp_tokens USING lv_before CHANGING lt_before cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  PERFORM wa_bsp_tokens USING lv_wanted CHANGING lt_wanted cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  IF lt_before <> lt_wanted.
    cv_error = 'Layout의 서버 측 구문/지시문 변경: 이번 버전은 기존 구문을 유지해야 합니다.'. RETURN.
  ENDIF.
* SPLIT omits the empty segment after its final delimiter. Add one delimiter
* so a significant final empty source row survives the table conversion.
  CONCATENATE lv_wanted cl_abap_char_utilities=>newline
    INTO lv_split RESPECTING BLANKS.
  SPLIT lv_split AT cl_abap_char_utilities=>newline INTO TABLE lt_lines.
  LOOP AT lt_lines INTO lv_line.
    ADD 1 TO lv_row. lv_length = strlen( lv_line ).
    APPEND INITIAL LINE TO lt_content ASSIGNING <ls_line>.
    UNASSIGN: <lv_cell>, <lv_second>.
    DESCRIBE FIELD <ls_line> TYPE lv_kind.
    IF lv_kind = 'u' OR lv_kind = 'v'.
      ASSIGN COMPONENT 1 OF STRUCTURE <ls_line> TO <lv_cell>.
      IF sy-subrc <> 0.
        PERFORM wa_bsp_line_error USING '행 필드 없음' lv_row lv_length 0
          CHANGING cv_error. RETURN.
      ENDIF.
      ASSIGN COMPONENT 2 OF STRUCTURE <ls_line> TO <lv_second>.
      IF sy-subrc = 0.
        PERFORM wa_bsp_line_error USING '여러 필드를 가진 행은 지원하지 않음' lv_row lv_length 0
          CHANGING cv_error. RETURN.
      ENDIF.
    ELSE. ASSIGN <ls_line> TO <lv_cell>.
    ENDIF.
    PERFORM wa_bsp_line_assign USING lv_line lv_row
      CHANGING <lv_cell> lv_round cv_error.
    IF cv_error IS NOT INITIAL. RETURN. ENDIF.
* Rebuild from the verified source extent of each row, not fixed-field width.
* Do not change web_lines: it also exports unrelated ABAP sources.
    IF lv_row = 1. lv_again = lv_round.
    ELSE.
      CONCATENATE lv_again cl_abap_char_utilities=>newline lv_round
        INTO lv_again RESPECTING BLANKS.
    ENDIF.
  ENDLOOP.
  IF lv_again <> lv_wanted.
    cv_error = 'BSP Layout 행 변환 후 내용/줄바꿈 불일치: 저장하지 않습니다.'. RETURN.
  ENDIF.
* Publish only a fully verified table; failed conversions leave no partial data.
  ct_content = lt_content.
ENDFORM.

FORM wa_bsp_so2_dom USING pv_xml TYPE xstring
                   CHANGING co_root TYPE REF TO if_ixml_node cv_error TYPE string.
  DATA: lo_ixml TYPE REF TO if_ixml, lo_sf TYPE REF TO if_ixml_stream_factory,
        lo_in TYPE REF TO if_ixml_istream, lo_doc TYPE REF TO if_ixml_document,
        lo_parser TYPE REF TO if_ixml_parser, lo_issue TYPE REF TO if_ixml_parse_error,
        lo_wrapper TYPE REF TO if_ixml_node, lo_node TYPE REF TO if_ixml_node,
        lv_type TYPE i, lv_text TYPE string, lv_name TYPE string, lv_rc TYPE i.
  CLEAR: co_root, cv_error.
  lo_ixml = cl_ixml=>create( ). lo_sf = lo_ixml->create_stream_factory( ).
  lo_doc = lo_ixml->create_document( ).
  lo_in = lo_sf->create_istream_xstring( string = pv_xml ).
  lo_parser = lo_ixml->create_parser( stream_factory = lo_sf
    istream = lo_in document = lo_doc ).
  lv_rc = lo_parser->parse( ).
  IF lv_rc <> 0.
    cv_error = 'SO2 Layout XML 해석 실패'.
    lo_issue = lo_parser->get_error( index = 0 ).
    IF lo_issue IS NOT INITIAL. cv_error = lo_issue->get_reason( ). ENDIF.
    RETURN.
  ENDIF.
  lo_wrapper = lo_doc->get_root_element( ).
  lo_node = lo_wrapper->get_first_child( ).
  WHILE lo_node IS NOT INITIAL.
    lv_type = lo_node->get_type( ).
    IF lv_type = if_ixml_node=>co_node_element.
      lv_name = lo_node->get_name( ).
      IF co_root IS NOT INITIAL OR ( lv_name <> 'page' AND lv_name <> 'so2:page' ).
        cv_error = 'SO2 Layout의 단일 page 루트를 확인할 수 없습니다.'. RETURN.
      ENDIF.
      co_root = lo_node.
    ELSE.
      lv_text = lo_node->get_value( ).
      REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>newline IN lv_text WITH ''.
      REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>horizontal_tab IN lv_text WITH ''.
      IF lv_type <> if_ixml_node=>co_node_text OR lv_text CN space.
        cv_error = 'SO2 page 밖에 지원하지 않는 XML 내용이 있습니다.'. RETURN.
      ENDIF.
    ENDIF.
    lo_node = lo_node->get_next( ).
  ENDWHILE.
  IF co_root IS INITIAL. cv_error = 'SO2 page 루트가 없습니다.'. ENDIF.
ENDFORM.

FORM wa_bsp_so2_parse USING pv_raw TYPE xstring
                     CHANGING co_root TYPE REF TO if_ixml_node cv_header TYPE string
                              cv_found TYPE c cv_error TYPE string.
  DATA: lv_text TYPE string, lv_body TYPE string, lv_check TYPE string,
        lv_chunk TYPE string, lv_at TYPE i, lv_end TYPE i, lv_len TYPE i,
        lv_cr TYPE c, lv_xml TYPE xstring.
  CLEAR: co_root, cv_header, cv_found, cv_error.
  PERFORM im_decode USING pv_raw CHANGING lv_text cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf IN lv_text
    WITH cl_abap_char_utilities=>newline.
  lv_body = lv_text.
  IF lv_body CP '<?xml *' OR lv_body CP '<?xml*'.
    FIND FIRST OCCURRENCE OF '?>' IN lv_body MATCH OFFSET lv_end.
    IF sy-subrc <> 0 OR lv_end > 1024. RETURN. ENDIF.
    lv_len = lv_end + 2. cv_header = lv_body(lv_len). lv_body = lv_body+lv_len.
  ENDIF.
  lv_check = lv_body.
  REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>newline IN lv_check WITH ` `.
  REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>horizontal_tab IN lv_check WITH ` `.
  SHIFT lv_check LEFT DELETING LEADING space.
  IF lv_check NP '<so2:page *' AND lv_check NP '<so2:page>*'. RETURN. ENDIF.
  cv_found = 'X'. lv_cr = cl_abap_char_utilities=>cr_lf(1).
  IF lv_text CS lv_cr. cv_error = 'SO2 Layout에 단독 CR이 있습니다.'. RETURN. ENDIF.
* Validate declarations outside CDATA only. HTML DOCTYPE text inside CDATA
* is ordinary static source, never a parser DTD. Do not enable external entities.
  lv_check = lv_body.
  WHILE lv_check IS NOT INITIAL.
    FIND FIRST OCCURRENCE OF '<![CDATA[' IN lv_check MATCH OFFSET lv_at.
    IF sy-subrc <> 0. lv_chunk = lv_check. CLEAR lv_check.
    ELSE.
      lv_chunk = lv_check(lv_at). lv_len = lv_at + 9. lv_check = lv_check+lv_len.
      FIND FIRST OCCURRENCE OF ']]>' IN lv_check MATCH OFFSET lv_end.
      IF sy-subrc <> 0. cv_error = '닫히지 않은 SO2 CDATA 구간입니다.'. RETURN. ENDIF.
      lv_len = lv_end + 3. lv_check = lv_check+lv_len.
    ENDIF.
    TRANSLATE lv_chunk TO UPPER CASE.
    IF lv_chunk CS '<!DOCTYPE' OR lv_chunk CS '<!ENTITY'.
      cv_error = 'SO2 Layout의 외부 DTD/ENTITY는 허용하지 않습니다.'. RETURN.
    ENDIF.
  ENDWHILE.
* GET_PAGE P_XML_SOURCE may omit xmlns:so2. Supply a namespace only in this
* temporary parser wrapper; raw ZIP, baseline and SAP source stay unchanged.
  CONCATENATE cv_header '<diag_so2 xmlns:so2="urn:devhub:bsp-so2" xml:space="preserve">'
    lv_body '</diag_so2>' INTO lv_text RESPECTING BLANKS.
  PERFORM utf8 USING lv_text CHANGING lv_xml.
  PERFORM wa_bsp_so2_dom USING lv_xml CHANGING co_root cv_error.
ENDFORM.

FORM wa_bsp_so2_attrs USING po_node TYPE REF TO if_ixml_node
                     CHANGING ct_attrs TYPE wa_so2_attrs cv_row TYPE i cv_col TYPE i
                              cv_error TYPE string.
  DATA: lo_map TYPE REF TO if_ixml_named_node_map, lo_attr TYPE REF TO if_ixml_node,
        ls_attr TYPE wa_so2_attr, lv_n TYPE i, lv_i TYPE i, lv_number TYPE i.
  REFRESH ct_attrs. CLEAR: cv_row, cv_col.
  lo_map = po_node->get_attributes( ).
  IF lo_map IS INITIAL. RETURN. ENDIF.
  lv_n = lo_map->get_length( ).
  IF lv_n > 256. cv_error = 'SO2 속성 개수 한도 초과'. RETURN. ENDIF.
  WHILE lv_i < lv_n.
    lo_attr = lo_map->get_item( index = lv_i ). ADD 1 TO lv_i.
    IF lo_attr IS INITIAL. cv_error = 'SO2 XML 속성 조회 실패'. RETURN. ENDIF.
    ls_attr-name = lo_attr->get_name( ). ls_attr-uri = lo_attr->get_namespace_uri( ).
    ls_attr-value = lo_attr->get_value( ). APPEND ls_attr TO ct_attrs.
    IF ls_attr-uri IS INITIAL AND ( ls_attr-name = 'x' OR ls_attr-name = 'y' ).
      IF ls_attr-value IS INITIAL OR strlen( ls_attr-value ) > 8 OR
         ls_attr-value CN '0123456789'.
        cv_error = 'SO2 원본 행/열 좌표 형식 오류'. RETURN.
      ENDIF.
      lv_number = ls_attr-value.
      IF lv_number < 1. cv_error = 'SO2 원본 행/열 좌표는 1 이상이어야 합니다.'. RETURN. ENDIF.
      IF ls_attr-name = 'x'. cv_row = lv_number. ELSE. cv_col = lv_number. ENDIF.
    ENDIF.
  ENDWHILE.
  SORT ct_attrs BY uri name value.
ENDFORM.

FORM wa_bsp_so2_text USING po_node TYPE REF TO if_ixml_node
                    CHANGING cv_text TYPE string cv_error TYPE string.
  DATA: lo_child TYPE REF TO if_ixml_node, lv_type TYPE i, lv_value TYPE string.
  CLEAR cv_text. lo_child = po_node->get_first_child( ).
  WHILE lo_child IS NOT INITIAL.
    lv_type = lo_child->get_type( ).
    IF lv_type <> if_ixml_node=>co_node_text AND
       lv_type <> if_ixml_node=>co_node_cdata_section.
      cv_error = 'SO2 static 안에는 문자/CDATA만 허용합니다.'. RETURN.
    ENDIF.
    lv_value = lo_child->get_value( ).
    CONCATENATE cv_text lv_value INTO cv_text RESPECTING BLANKS.
    lo_child = lo_child->get_next( ).
  ENDWHILE.
ENDFORM.

FORM wa_bsp_so2_pair USING po_a TYPE REF TO if_ixml_node po_b TYPE REF TO if_ixml_node
                          pv_depth TYPE i
                    CHANGING ct_parts TYPE wa_so2_parts cv_nodes TYPE i cv_error TYPE string.
  DATA: lv_type_a TYPE i, lv_type_b TYPE i, lv_name_a TYPE string, lv_name_b TYPE string,
        lv_uri_a TYPE string, lv_uri_b TYPE string, lv_value_a TYPE string, lv_value_b TYPE string,
        lt_attrs_a TYPE wa_so2_attrs, lt_attrs_b TYPE wa_so2_attrs,
        lv_row_a TYPE i, lv_col_a TYPE i, lv_row_b TYPE i, lv_col_b TYPE i,
        lo_a TYPE REF TO if_ixml_node, lo_b TYPE REF TO if_ixml_node,
        lv_depth TYPE i, ls_part TYPE wa_so2_part.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  ADD 1 TO cv_nodes.
  IF pv_depth > 96 OR cv_nodes > 30000.
    cv_error = 'SO2 XML 분석 한도 초과'. RETURN.
  ENDIF.
  lv_type_a = po_a->get_type( ). lv_type_b = po_b->get_type( ).
  lv_name_a = po_a->get_name( ). lv_name_b = po_b->get_name( ).
  lv_uri_a = po_a->get_namespace_uri( ). lv_uri_b = po_b->get_namespace_uri( ).
  IF lv_type_a <> lv_type_b OR lv_name_a <> lv_name_b OR lv_uri_a <> lv_uri_b.
    cv_error = 'SO2 XML 구조/서버 구문 변경: 기존 static 본문만 수정하십시오.'. RETURN.
  ENDIF.
  PERFORM wa_bsp_so2_attrs USING po_a CHANGING lt_attrs_a lv_row_a lv_col_a cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  PERFORM wa_bsp_so2_attrs USING po_b CHANGING lt_attrs_b lv_row_b lv_col_b cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  IF lt_attrs_a <> lt_attrs_b.
    cv_error = 'SO2 속성/좌표/서버 지시문 변경: XML 메타데이터는 원본을 유지하십시오.'. RETURN.
  ENDIF.
  IF lv_type_a = if_ixml_node=>co_node_element AND
     ( lv_name_a = 'static' OR lv_name_a = 'so2:static' ).
    IF pv_depth <> 1 OR lv_row_a < 1 OR lv_col_a < 1.
      cv_error = 'SO2 static 위치/중첩 형식을 지원하지 않습니다.'. RETURN.
    ENDIF.
    ls_part-row = lv_row_a. ls_part-col = lv_col_a.
    PERFORM wa_bsp_so2_text USING po_a CHANGING ls_part-original cv_error.
    IF cv_error IS NOT INITIAL. RETURN. ENDIF.
    PERFORM wa_bsp_so2_text USING po_b CHANGING ls_part-wanted cv_error.
    IF cv_error IS NOT INITIAL. RETURN. ENDIF.
    APPEND ls_part TO ct_parts. RETURN.
  ENDIF.
  IF lv_type_a <> if_ixml_node=>co_node_element.
    lv_value_a = po_a->get_value( ). lv_value_b = po_b->get_value( ).
    IF lv_value_a <> lv_value_b.
      cv_error = 'SO2 서버 스크립트/구조 문자 변경: static 본문만 수정하십시오.'. RETURN.
    ENDIF.
  ENDIF.
  lo_a = po_a->get_first_child( ). lo_b = po_b->get_first_child( ).
  WHILE lo_a IS NOT INITIAL AND lo_b IS NOT INITIAL.
    lv_depth = pv_depth + 1.
    PERFORM wa_bsp_so2_pair USING lo_a lo_b lv_depth CHANGING ct_parts cv_nodes cv_error.
    IF cv_error IS NOT INITIAL. RETURN. ENDIF.
    lo_a = lo_a->get_next( ). lo_b = lo_b->get_next( ).
  ENDWHILE.
  IF lo_a IS NOT INITIAL OR lo_b IS NOT INITIAL.
    cv_error = 'SO2 XML 노드 추가/삭제: 기존 static 본문만 수정하십시오.'.
  ENDIF.
ENDFORM.

FORM wa_bsp_so2_row USING pt_content TYPE o2pageline_table pv_row TYPE i
                   CHANGING cv_full TYPE string cv_used TYPE i cv_error TYPE string.
  DATA: lv_kind TYPE c, lv_empty TYPE string.
  FIELD-SYMBOLS: <ls_row> TYPE ANY, <lv_cell> TYPE ANY, <lv_second> TYPE ANY.
  CLEAR: cv_full, cv_used.
  READ TABLE pt_content ASSIGNING <ls_row> INDEX pv_row.
  IF sy-subrc <> 0. cv_error = 'SO2 원본 좌표가 SAP Layout 행 범위를 벗어났습니다.'. RETURN. ENDIF.
  DESCRIBE FIELD <ls_row> TYPE lv_kind.
  IF lv_kind = 'u' OR lv_kind = 'v'.
    ASSIGN COMPONENT 1 OF STRUCTURE <ls_row> TO <lv_cell>.
    IF sy-subrc <> 0. cv_error = 'SO2 SAP 행 필드 없음'. RETURN. ENDIF.
    ASSIGN COMPONENT 2 OF STRUCTURE <ls_row> TO <lv_second>.
    IF sy-subrc = 0. cv_error = 'SO2 SAP 행의 다중 필드는 지원하지 않습니다.'. RETURN. ENDIF.
  ELSE. ASSIGN <ls_row> TO <lv_cell>. ENDIF.
  DESCRIBE FIELD <lv_cell> TYPE lv_kind.
  IF lv_kind <> 'C' AND lv_kind <> 'g'. cv_error = 'SO2 SAP 행이 문자형이 아닙니다.'. RETURN. ENDIF.
  CONCATENATE <lv_cell> lv_empty INTO cv_full RESPECTING BLANKS.
* STRLEN on fixed C excludes indistinguishable padding; STRING keeps spaces.
* XML static extents preserve their explicit spaces; full typed-row proof below
* is mandatory before publishing any expected SET_PAGE content.
  cv_used = strlen( <lv_cell> ).
ENDFORM.

FORM wa_bsp_so2_gap USING pt_content TYPE o2pageline_table pv_end_row TYPE i pv_end_col TYPE i
                   CHANGING cv_row TYPE i cv_col TYPE i cv_text TYPE string cv_error TYPE string.
  DATA: lv_rows TYPE i, lv_full TYPE string, lv_used TYPE i, lv_offset TYPE i,
        lv_length TYPE i, lv_part TYPE string, lv_limit TYPE i.
  CLEAR cv_text. DESCRIBE TABLE pt_content LINES lv_rows. lv_limit = lv_rows + 1.
  IF pv_end_row < cv_row OR ( pv_end_row = cv_row AND pv_end_col < cv_col ) OR
     pv_end_row > lv_limit OR pv_end_col < 1 OR ( pv_end_row = lv_limit AND pv_end_col <> 1 ).
    cv_error = 'SO2 static 원본 좌표가 겹치거나 역순/범위 오류입니다.'. RETURN.
  ENDIF.
  WHILE cv_row < pv_end_row.
    PERFORM wa_bsp_so2_row USING pt_content cv_row CHANGING lv_full lv_used cv_error.
    IF cv_error IS NOT INITIAL. RETURN. ENDIF.
    lv_offset = cv_col - 1. CLEAR lv_part.
    IF lv_offset > strlen( lv_full ). cv_error = 'SO2 원본 열 좌표 범위 오류'. RETURN. ENDIF.
    IF lv_used > lv_offset.
      lv_length = lv_used - lv_offset. lv_part = lv_full+lv_offset(lv_length).
    ENDIF.
    CONCATENATE cv_text lv_part cl_abap_char_utilities=>newline INTO cv_text RESPECTING BLANKS.
    ADD 1 TO cv_row. cv_col = 1.
  ENDWHILE.
  IF cv_col < pv_end_col.
    PERFORM wa_bsp_so2_row USING pt_content cv_row CHANGING lv_full lv_used cv_error.
    IF cv_error IS NOT INITIAL. RETURN. ENDIF.
    lv_offset = cv_col - 1. lv_length = pv_end_col - cv_col.
    lv_limit = lv_offset + lv_length.
    IF lv_limit > strlen( lv_full ). cv_error = 'SO2 원본 열 좌표 범위 오류'. RETURN. ENDIF.
    lv_part = lv_full+lv_offset(lv_length).
    CONCATENATE cv_text lv_part INTO cv_text RESPECTING BLANKS.
    cv_col = pv_end_col.
  ENDIF.
ENDFORM.

FORM wa_bsp_so2_span USING pt_content TYPE o2pageline_table pv_text TYPE string
                    CHANGING cv_row TYPE i cv_col TYPE i cv_error TYPE string.
  DATA: lt_lines TYPE ty_lines, lv_line TYPE string, lv_split TYPE string,
        lv_full TYPE string, lv_used TYPE i, lv_offset TYPE i, lv_length TYPE i,
        lv_end TYPE i, lv_rows TYPE i, lv_count TYPE i, lv_index TYPE i,
        lv_last TYPE i, lv_n TYPE c LENGTH 12.
  CONCATENATE pv_text cl_abap_char_utilities=>newline INTO lv_split RESPECTING BLANKS.
  SPLIT lv_split AT cl_abap_char_utilities=>newline INTO TABLE lt_lines.
  DESCRIBE TABLE pt_content LINES lv_rows. lv_last = lv_rows + 1.
  DESCRIBE TABLE lt_lines LINES lv_count.
  LOOP AT lt_lines INTO lv_line.
    ADD 1 TO lv_index. lv_length = strlen( lv_line ).
    IF cv_row = lv_last AND cv_col = 1 AND lv_index = lv_count AND lv_length = 0. CONTINUE. ENDIF.
    PERFORM wa_bsp_so2_row USING pt_content cv_row CHANGING lv_full lv_used cv_error.
    IF cv_error IS NOT INITIAL. RETURN. ENDIF.
    lv_offset = cv_col - 1. lv_end = lv_offset + lv_length.
    IF lv_end > strlen( lv_full ).
      cv_error = 'SO2 static 원본이 SAP 행 길이를 초과합니다.'. RETURN.
    ENDIF.
    IF lv_full+lv_offset(lv_length) <> lv_line OR
       ( lv_index < lv_count AND lv_used > lv_end ).
      WRITE cv_row TO lv_n NO-GROUPING. CONDENSE lv_n.
      CONCATENATE 'SO2 static 원본/API 본문 불일치: SAP 행=' lv_n INTO cv_error. RETURN.
    ENDIF.
    IF lv_index < lv_count. ADD 1 TO cv_row. cv_col = 1.
    ELSE. cv_col = lv_end + 1. ENDIF.
  ENDLOOP.
ENDFORM.

FORM wa_bsp_so2_content USING pv_before TYPE xstring pv_wanted TYPE xstring
                                pt_current TYPE o2pageline_table
                       CHANGING cv_found TYPE c ct_content TYPE o2pageline_table
                                cv_detail TYPE string cv_error TYPE string.
  DATA: lo_a TYPE REF TO if_ixml_node, lo_b TYPE REF TO if_ixml_node,
        lv_header_a TYPE string, lv_header_b TYPE string, lv_found_b TYPE c,
        lt_parts TYPE wa_so2_parts, ls_part TYPE wa_so2_part, lv_nodes TYPE i,
        lv_row TYPE i, lv_col TYPE i, lv_end_row TYPE i, lv_gap TYPE string,
        lv_before TYPE string, lv_wanted TYPE string, lv_raw_a TYPE xstring, lv_raw_b TYPE xstring,
        lt_before TYPE o2pageline_table, lt_wanted TYPE o2pageline_table,
        lv_equal TYPE c, lv_compare TYPE string, lv_n TYPE c LENGTH 12, lv_changed TYPE i.
  REFRESH ct_content. CLEAR: cv_found, cv_error.
  PERFORM wa_bsp_so2_parse USING pv_before CHANGING lo_a lv_header_a cv_found cv_error.
  IF cv_found <> 'X' OR cv_error IS NOT INITIAL. RETURN. ENDIF.
  cv_detail = 'BASELINE_CHECK:mode=SO2_XML; 원본/API 대응 확인 중'.
  PERFORM wa_bsp_so2_parse USING pv_wanted CHANGING lo_b lv_header_b lv_found_b cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  IF lv_found_b <> 'X' OR lv_header_a <> lv_header_b.
    cv_error = 'SO2 XML 형식/선언 변경: 업로드는 원본 XML 구조를 유지하십시오.'. RETURN.
  ENDIF.
  PERFORM wa_bsp_so2_pair USING lo_a lo_b 0 CHANGING lt_parts lv_nodes cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  IF lt_parts IS INITIAL. cv_error = 'SO2 Layout에 지원하는 static 본문이 없습니다.'. RETURN. ENDIF.
  lv_row = 1. lv_col = 1.
  LOOP AT lt_parts INTO ls_part.
    PERFORM wa_bsp_so2_gap USING pt_current ls_part-row ls_part-col
      CHANGING lv_row lv_col lv_gap cv_error.
    IF cv_error IS NOT INITIAL. RETURN. ENDIF.
    CONCATENATE lv_before lv_gap ls_part-original INTO lv_before RESPECTING BLANKS.
    CONCATENATE lv_wanted lv_gap ls_part-wanted INTO lv_wanted RESPECTING BLANKS.
    PERFORM wa_bsp_so2_span USING pt_current ls_part-original CHANGING lv_row lv_col cv_error.
    IF cv_error IS NOT INITIAL. RETURN. ENDIF.
    IF ls_part-original <> ls_part-wanted. ADD 1 TO lv_changed. ENDIF.
  ENDLOOP.
  DESCRIBE TABLE pt_current LINES lv_end_row. ADD 1 TO lv_end_row.
  PERFORM wa_bsp_so2_gap USING pt_current lv_end_row 1 CHANGING lv_row lv_col lv_gap cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  CONCATENATE lv_before lv_gap INTO lv_before RESPECTING BLANKS.
  CONCATENATE lv_wanted lv_gap INTO lv_wanted RESPECTING BLANKS.
  PERFORM utf8 USING lv_before CHANGING lv_raw_a. PERFORM utf8 USING lv_wanted CHANGING lv_raw_b.
  PERFORM wa_bsp_content USING lv_raw_a lv_raw_a CHANGING lt_before cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  PERFORM wa_bsp_compare_lines USING lt_before pt_current CHANGING lv_equal lv_compare.
  IF lv_equal <> 'X'.
    CONCATENATE 'SO2 원본 전체/API Layout 대응 실패:' lv_compare INTO cv_error SEPARATED BY space. RETURN.
  ENDIF.
* Only static text changed; directives/scripts are copied from live P_CONTENT.
* Existing server-token, UTF-8, line-capacity and native readback checks remain.
  PERFORM wa_bsp_content USING lv_raw_a lv_raw_b CHANGING lt_wanted cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  ct_content = lt_wanted. WRITE lv_changed TO lv_n NO-GROUPING. CONDENSE lv_n.
  CONCATENATE 'BASELINE_CHECK:mode=SO2_XML; ' lv_compare
    '; XML 구조/서버 구문 보존; 변경 static 구간=' lv_n INTO cv_detail.
ENDFORM.

FORM wa_bsp_xml_declaration USING pv_raw TYPE xstring
                            CHANGING cv_header TYPE string cv_body TYPE xstring
                                     cv_found TYPE c cv_error TYPE string.
  DATA: lv_text TYPE string, lv_at TYPE i, lv_start TYPE i, lv_header TYPE string,
        lv_pattern TYPE string, lv_match TYPE string.
  CLEAR: cv_header, cv_body, cv_found, cv_error.
  PERFORM im_decode USING pv_raw CHANGING lv_text cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf IN lv_text
    WITH cl_abap_char_utilities=>newline.
* Recognize one standalone UTF-8 XML declaration, never arbitrary processing
* instructions, wrappers, leading blank lines or declarations inside HTML.
  FIND FIRST OCCURRENCE OF cl_abap_char_utilities=>newline IN lv_text MATCH OFFSET lv_at.
  IF sy-subrc <> 0 OR lv_at < 5 OR lv_at > 1024. RETURN. ENDIF.
  lv_header = lv_text(lv_at).
* Only the declaration syntax check treats tabs as XML whitespace. Retain
* the original header for exact A/B equality and never alter the body.
  lv_match = lv_header.
  REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>horizontal_tab IN lv_match WITH ` `.
  CONCATENATE
    `^[<][?]xml[ ]+version[ ]*=[ ]*("1[.]0"|'1[.]0')`
    `([ ]+encoding[ ]*=[ ]*("[Uu][Tt][Ff]-8"|'[Uu][Tt][Ff]-8'))?`
    `([ ]+standalone[ ]*=[ ]*("yes"|"no"|'yes'|'no'))?`
    `[ ]*[?][>][ ]*$` INTO lv_pattern.
  FIND REGEX lv_pattern IN lv_match.
  IF sy-subrc <> 0. RETURN. ENDIF.
  lv_start = lv_at + 1. lv_text = lv_text+lv_start.
* Preserve the body's final newline here; wa_bsp_content applies its existing
* one-terminal-newline policy exactly once, not once per adapter.
  PERFORM utf8 USING lv_text CHANGING cv_body.
  cv_header = lv_header. cv_found = 'X'.
ENDFORM.

FORM wa_bsp_export_content USING pv_before TYPE xstring pv_wanted TYPE xstring
                                pt_current TYPE o2pageline_table
                          CHANGING ct_content TYPE o2pageline_table
                                   cv_detail TYPE string cv_error TYPE string.
  DATA: lt_before TYPE o2pageline_table, lt_wanted TYPE o2pageline_table,
        lv_before TYPE xstring, lv_wanted TYPE xstring,
        lv_header_a TYPE string, lv_header_b TYPE string,
        lv_found_a TYPE c, lv_found_b TYPE c, lv_equal TYPE c, lv_so2 TYPE c,
        lv_direct TYPE string, lv_compare TYPE string, lv_error TYPE string.
  REFRESH ct_content. CLEAR: cv_detail, cv_error.
* Direct correspondence has priority: a real XML declaration in a BSP page
* must stay in that page. Representation conversion is not a new conflict gate.
  PERFORM wa_bsp_content USING pv_before pv_before CHANGING lt_before lv_error.
  IF lv_error IS INITIAL.
    PERFORM wa_bsp_compare_lines USING lt_before pt_current CHANGING lv_equal lv_direct.
  ELSE. lv_direct = lv_error. ENDIF.
  IF lv_equal = 'X'.
    CONCATENATE 'BASELINE_CHECK:mode=DIRECT; ' lv_direct INTO cv_detail.
    PERFORM wa_bsp_content USING pv_before pv_wanted CHANGING ct_content cv_error.
    RETURN.
  ENDIF.
  CONCATENATE 'BASELINE_CHECK:mode=UNRESOLVED; ' lv_direct INTO cv_detail.
  PERFORM wa_bsp_so2_content USING pv_before pv_wanted pt_current
    CHANGING lv_so2 ct_content cv_detail cv_error.
  IF lv_so2 = 'X' OR cv_error IS NOT INITIAL. RETURN. ENDIF.
  PERFORM wa_bsp_xml_declaration USING pv_before
    CHANGING lv_header_a lv_before lv_found_a cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  IF lv_found_a <> 'X'.
    CONCATENATE '원본/API Layout 표현 불일치:' lv_direct
      '; 선두 XML 선언행 확인 불가. JSON 및 원본 Layout 확인 필요.'
      INTO cv_error SEPARATED BY space. RETURN.
  ENDIF.
* Full baseline proof is mandatory. A one-row count difference alone is
* insufficient, and no row/character differences in the body are ignored.
  PERFORM wa_bsp_content USING lv_before lv_before CHANGING lt_before cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  PERFORM wa_bsp_compare_lines USING lt_before pt_current CHANGING lv_equal lv_compare.
  CONCATENATE cv_detail '; XML_DECL_CANDIDATE: ' lv_compare INTO cv_detail.
  IF lv_equal <> 'X'.
    CONCATENATE 'XML 선언행 제외 후에도 원본/API Layout 불일치:' lv_compare
      INTO cv_error SEPARATED BY space. RETURN.
  ENDIF.
  PERFORM wa_bsp_xml_declaration USING pv_wanted
    CHANGING lv_header_b lv_wanted lv_found_b cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  IF lv_found_b <> 'X' OR lv_header_a <> lv_header_b.
    cv_error = 'Export XML 선언행이 수정/누락되었습니다. 원본 선언행을 유지하고 Layout 본문만 수정하십시오.'.
    RETURN.
  ENDIF.
* The same proven representation is used for both baseline and upload. Server
* tokens, row capacities and body whitespace still pass the existing checks.
  PERFORM wa_bsp_content USING lv_before lv_wanted CHANGING lt_wanted cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  ct_content = lt_wanted.
  CONCATENATE 'BASELINE_CHECK:mode=XML_DECLARATION; 선두 선언행 1개 분리; ' lv_compare
    '; 업로드 선언행 원본 일치; 본문 전체 대응 확인' INTO cv_detail.
ENDFORM.

FORM wa_bsp_clear_generated CHANGING cs_data TYPE ANY.
  DATA: lt_names TYPE ty_lines, lv_name TYPE string.
  FIELD-SYMBOLS <lv_value> TYPE ANY.
* Only SAP-managed generation/change bookkeeping may differ after SAVE.
  SPLIT 'VERSION CHANGEDBY CHANGEDON CHANGETIME GENDATE GENTIME IMPLCLASS'
    AT space INTO TABLE lt_names.
  LOOP AT lt_names INTO lv_name.
    ASSIGN COMPONENT lv_name OF STRUCTURE cs_data TO <lv_value>.
    IF sy-subrc = 0. CLEAR <lv_value>. ENDIF.
  ENDLOOP.
ENDFORM.

FORM wa_bsp_guard USING ps_snapshot TYPE wa_bsp_snapshot CHANGING cv_raw TYPE xstring.
  DATA: ls_attrs TYPE o2pagattr, ls_app TYPE o2applattr.
  ls_attrs = ps_snapshot-attrs. ls_app = ps_snapshot-app_attrs.
  PERFORM wa_bsp_clear_generated CHANGING ls_attrs.
  PERFORM wa_bsp_clear_generated CHANGING ls_app.
  CALL TRANSFORMATION id SOURCE properties = ls_attrs
    page_attributes = ps_snapshot-parameters events = ps_snapshot-events
    types = ps_snapshot-types application = ls_app RESULT XML cv_raw.
ENDFORM.

FORM wa_bsp_probe.
  DATA: ls_request TYPE wa_bsp_request, ls_result TYPE wa_bsp_snapshot,
        lo_page TYPE REF TO cl_o2_api_pages, lo_app TYPE REF TO cl_o2_api_application,
        lv_version TYPE ty_bsp_version,
        lv_text TYPE string, lv_ok TYPE c, lv_type TYPE c, lv_kind_text TYPE string,
        lo_error TYPE REF TO cx_root.
* This branch only reads SAP. It is invoked by SUBMIT AND RETURN, so API
* static caches from SET_PAGE/SAVE cannot satisfy the post-activation check.
  IMPORT request = ls_request FROM MEMORY ID 'Z_PACKAGE_DIAG_BSP_READ'.
  IF sy-subrc <> 0 OR ls_request-key IS INITIAL OR ls_request-nonce <= 0. RETURN. ENDIF.
  TRY.
      CALL METHOD cl_o2_api_pages=>load
        EXPORTING p_pagekey = ls_request-key p_version = ls_request-version
          p_langu = ls_request-langu p_with_all_texts = space p_load_for_generation = space
        IMPORTING p_page = lo_page EXCEPTIONS OTHERS = 1.
      IF sy-subrc <> 0 OR lo_page IS INITIAL.
        ls_result-error = 'BSP fresh active LOAD failed'.
      ELSE.
        lv_version = lo_page->get_version( ).
        IF lv_version <> ls_request-version. ls_result-error = 'BSP fresh read returned a different version'. ENDIF.
      ENDIF.
      IF ls_result-error IS INITIAL.
        CALL METHOD lo_page->get_attrs IMPORTING p_attrs = ls_result-attrs EXCEPTIONS OTHERS = 1.
        IF sy-subrc <> 0. ls_result-error = 'BSP GET_ATTRS failed'. ENDIF.
      ENDIF.
      IF ls_result-error IS INITIAL.
        lv_type = ls_result-attrs-pagetype.
        PERFORM wa_bsp_page_kind USING lv_type CHANGING lv_ok lv_kind_text.
        IF lv_ok <> 'X'.
          CONCATENATE 'BSP 활성/미활성 조회: 지원하지 않는 페이지 유형' lv_kind_text
            INTO ls_result-error SEPARATED BY space.
        ENDIF.
      ENDIF.
      IF ls_result-error IS INITIAL.
        CALL METHOD lo_page->get_page IMPORTING p_content = ls_result-content
          p_xml_source = ls_result-layout EXCEPTIONS OTHERS = 1.
        IF sy-subrc <> 0. ls_result-error = 'BSP GET_PAGE failed'.
        ELSEIF ls_result-layout IS INITIAL AND ls_result-content IS NOT INITIAL.
          gv_lf = cl_abap_char_utilities=>newline.
          PERFORM web_lines USING ls_result-content CHANGING lv_text lv_ok.
          IF lv_ok <> 'X'. ls_result-error = 'BSP text content cannot be decoded'.
          ELSE. PERFORM utf8 USING lv_text CHANGING ls_result-layout.
          ENDIF.
        ENDIF.
      ENDIF.
      IF ls_result-error IS INITIAL.
        CALL METHOD lo_page->get_event_handlers IMPORTING p_ev_handler = ls_result-events
          EXCEPTIONS OTHERS = 1.
        IF sy-subrc <> 0. ls_result-error = 'BSP GET_EVENT_HANDLERS failed'. ENDIF.
      ENDIF.
      IF ls_result-error IS INITIAL.
        CALL METHOD lo_page->get_parameters IMPORTING p_parameters = ls_result-parameters
          EXCEPTIONS OTHERS = 1.
        IF sy-subrc <> 0. ls_result-error = 'BSP GET_PARAMETERS failed'. ENDIF.
      ENDIF.
      IF ls_result-error IS INITIAL.
        CALL METHOD lo_page->get_type_source IMPORTING p_source = ls_result-types EXCEPTIONS OTHERS = 1.
        IF sy-subrc <> 0. ls_result-error = 'BSP GET_TYPE_SOURCE failed'. ENDIF.
      ENDIF.
      IF ls_result-error IS INITIAL.
        CALL METHOD cl_o2_api_application=>load EXPORTING p_application_name = ls_request-key-applname
          IMPORTING p_application = lo_app EXCEPTIONS OTHERS = 1.
        IF sy-subrc <> 0 OR lo_app IS INITIAL. ls_result-error = 'BSP application LOAD failed'. ENDIF.
      ENDIF.
      IF ls_result-error IS INITIAL.
        CALL METHOD lo_app->get_attributes EXPORTING p_version = 'A'
          IMPORTING p_attributes = ls_result-app_attrs EXCEPTIONS OTHERS = 1.
        IF sy-subrc <> 0. ls_result-error = 'BSP active application attributes unavailable'. ENDIF.
      ENDIF.
      IF ls_result-error IS INITIAL.
        PERFORM wa_bsp_pending_probe USING ls_request-key CHANGING ls_result ls_result-error.
      ENDIF.
    CATCH cx_root INTO lo_error. ls_result-error = lo_error->get_text( ).
  ENDTRY.
  EXPORT result = ls_result nonce = ls_request-nonce TO MEMORY ID 'Z_PACKAGE_DIAG_BSP_READ'.
ENDFORM.

FORM wa_bsp_object_state USING pv_object TYPE e071-object pv_key TYPE e071-obj_name
                        CHANGING cv_pending TYPE c cv_detail TYPE string cv_error TYPE string.
  DATA: lt_objects TYPE STANDARD TABLE OF e071, ls_object TYPE e071,
        lt_messages TYPE wa_bsp_protocol_rows, lt_worklist TYPE wa_bsp_worklist,
        lv_protocol TYPE string, lv_fm TYPE rs38l-name,
        lv_xml TYPE xstring, lv_rc TYPE sysubrc, lo_error TYPE REF TO cx_root.
  CLEAR: cv_pending, cv_detail, cv_error.
  TRY.
      ls_object-pgmid = 'LIMU'. ls_object-object = pv_object.
      ls_object-obj_name = pv_key. APPEND ls_object TO lt_objects.
      lv_fm = 'RS_INACTIVE_OBJECTS_WARNING'.
* Request the protocol as data. Do not suppress the evidence we must inspect.
* One exact subobject per call; never send WAPA or an application page list.
      CALL FUNCTION lv_fm EXPORTING suppress_protocol = space with_program_includes = space
        suppress_dictionary_check = 'X' TABLES p_e071 = lt_objects p_xmsg = lt_messages
        EXCEPTIONS error_message = 1 OTHERS = 2.
      lv_rc = sy-subrc.
      IF lv_rc <> 0.
        PERFORM wa_api_error USING 'BSP inactive-state query' lv_rc CHANGING cv_error.
      ELSE.
* A WAPD query may return WAPP messages. Query scope is not message scope.
* Exact worklist keys are independent evidence; never infer a full page key
* from SPROT_U-VAR2, whose field can truncate the SAP concatenated key.
        SELECT * FROM dwinactiv BYPASSING BUFFER INTO TABLE lt_worklist
          WHERE object = pv_object AND obj_name = pv_key.
        PERFORM wa_bsp_protocol USING pv_object pv_key lt_messages lt_worklist
          CHANGING cv_pending lv_protocol cv_error.
* Keep every SAP field plus the rendered system message and classification.
        CALL TRANSFORMATION id SOURCE object = pv_object object_key = pv_key
          messages = lt_messages exact_worklist = lt_worklist
          protocol_decision = lv_protocol RESULT XML lv_xml.
        PERFORM im_decode USING lv_xml CHANGING cv_detail lv_protocol.
        IF lv_protocol IS NOT INITIAL. cv_error = lv_protocol. ENDIF.
      ENDIF.
    CATCH cx_root INTO lo_error. cv_error = lo_error->get_text( ).
  ENDTRY.
  IF cv_error IS NOT INITIAL.
    CLEAR cv_pending.
    CONCATENATE 'BSP 미활성 조회 실패:' pv_object pv_key cv_error
      INTO cv_error SEPARATED BY space.
  ENDIF.
ENDFORM.

FORM wa_bsp_protocol USING pv_object TYPE e071-object pv_key TYPE e071-obj_name
                          pt_messages TYPE wa_bsp_protocol_rows pt_worklist TYPE wa_bsp_worklist
                    CHANGING cv_pending TYPE c cv_detail TYPE string cv_error TYPE string.
  DATA: ls_message TYPE sprot_u, ls_work TYPE dwinactiv,
        lv_projected TYPE sprot_u-var2, lv_text TYPE string,
        lv_line TYPE string, lv_scope TYPE string, lv_number TYPE string.
  CLEAR: cv_pending, cv_detail, cv_error.
  IF ( pv_object <> 'WAPP' AND pv_object <> 'WAPD' ) OR pv_key IS INITIAL.
    cv_error = 'BSP inactive query scope is invalid'. RETURN.
  ENDIF.
  LOOP AT pt_worklist INTO ls_work.
    IF ls_work-object <> pv_object OR ls_work-obj_name <> pv_key.
      cv_error = 'BSP inactive worklist returned an unexpected full key'. RETURN.
    ENDIF.
    cv_pending = 'X'.
  ENDLOOP.
  lv_projected = pv_key.
  LOOP AT pt_messages INTO ls_message.
    CLEAR: lv_scope, lv_text.
    IF ls_message-ag IS NOT INITIAL.
      MESSAGE ID ls_message-ag TYPE 'S' NUMBER ls_message-msgnr
        WITH ls_message-var1 ls_message-var2 ls_message-var3 ls_message-var4 INTO lv_text.
    ENDIF.
* EU829 identifies an inactive object in VAR1/VAR2. It is not a syntax
* result. A prefix match is only a review flag, never permission to write.
    IF ls_message-ag = 'EU' AND ls_message-msgnr = '829' AND
       ls_message-severity = 'E' AND ls_message-var2 IS NOT INITIAL.
      IF ls_message-var1 = pv_object.
        IF ls_message-var2 = lv_projected.
          cv_pending = 'X'. lv_scope = 'REQUESTED_OBJECT_REVIEW'.
        ELSE. lv_scope = 'OTHER_KEY_EVIDENCE'.
        ENDIF.
      ELSEIF pv_object = 'WAPD' AND ls_message-var1 = 'WAPP'.
        lv_scope = 'RELATED_WAPP_NOT_WAPD'.
      ELSE. lv_scope = 'UNRESOLVED_OBJECT_REVIEW'.
      ENDIF.
    ELSE. lv_scope = 'UNRESOLVED_MESSAGE_REVIEW'.
    ENDIF.
    lv_number = ls_message-msgnr.
    CONCATENATE lv_scope ls_message-ag lv_number ls_message-severity
      ls_message-var1 ls_message-var2 lv_text INTO lv_line SEPARATED BY space.
    IF cv_detail IS INITIAL. cv_detail = lv_line.
    ELSE. CONCATENATE cv_detail cl_abap_char_utilities=>newline lv_line
      INTO cv_detail RESPECTING BLANKS.
    ENDIF.
    IF lv_scope = 'UNRESOLVED_OBJECT_REVIEW' OR lv_scope = 'UNRESOLVED_MESSAGE_REVIEW'.
      IF cv_error IS INITIAL.
        CONCATENATE 'BSP 점검 메시지 확인 필요:' lv_line INTO cv_error SEPARATED BY space.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.

FORM wa_bsp_pending_probe USING ps_key TYPE o2pagkey
                         CHANGING cs_result TYPE wa_bsp_snapshot cv_error TYPE string.
  DATA: lv_objkey TYPE e071-obj_name, lv_pending TYPE c,
        lv_page_detail TYPE string, lv_app_detail TYPE string.
  REFRESH cs_result-inactive.
  CLEAR: cs_result-app_inactive, cs_result-inactive_detail, cv_error.
  PERFORM wa_bsp_object_key USING ps_key CHANGING lv_objkey cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  PERFORM wa_bsp_object_state USING 'WAPP' lv_objkey
    CHANGING lv_pending lv_page_detail cv_error.
  cs_result-inactive_detail = lv_page_detail.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
* This list is deliberately scoped to the requested page only (0 or 1 row).
* GET_ALL_PAGES(I) membership is not proof of an inactive selected page.
  IF lv_pending = 'X'. INSERT ps_key INTO TABLE cs_result-inactive. ENDIF.
  lv_objkey = ps_key-applname.
  PERFORM wa_bsp_object_state USING 'WAPD' lv_objkey
    CHANGING cs_result-app_inactive lv_app_detail cv_error.
  CONCATENATE lv_page_detail cl_abap_char_utilities=>newline lv_app_detail
    INTO cs_result-inactive_detail RESPECTING BLANKS.
ENDFORM.

FORM wa_bsp_pending_note USING ps_key TYPE o2pagkey ps_now TYPE wa_bsp_snapshot
                        CHANGING cv_state TYPE c cv_note TYPE string.
  cv_state = 'NONE'. CLEAR cv_note.
  READ TABLE ps_now-inactive WITH TABLE KEY applname = ps_key-applname
    pagekey = ps_key-pagekey TRANSPORTING NO FIELDS.
  IF sy-subrc = 0.
    cv_state = 'PAGE_REVIEW'.
    CONCATENATE '선택 페이지 WAPP 미활성/점검 경고:' ps_key-applname '/' ps_key-pagekey
      '- JSON wa_inactive_detail에서 SAP 원문 확인' INTO cv_note SEPARATED BY space.
  ENDIF.
  IF ps_now-app_inactive = 'X'.
    IF cv_state = 'PAGE_REVIEW'. cv_state = 'BOTH_REVIEW'. ELSE. cv_state = 'APP_REVIEW'. ENDIF.
    CONCATENATE cv_note '공통 정의 WAPD 미활성/점검 경고:' ps_key-applname
      '- 다른 HTM 변경과 별도 점검' INTO cv_note SEPARATED BY space.
  ENDIF.
ENDFORM.

FORM wa_bsp_fetch USING ps_key TYPE o2pagkey pv_langu TYPE sy-langu
                 CHANGING cs_result TYPE wa_bsp_snapshot cv_error TYPE string.
  PERFORM wa_bsp_fetch_version USING ps_key pv_langu 'A' CHANGING cs_result cv_error.
ENDFORM.

FORM wa_bsp_resume_owner USING ps_target TYPE wa_target CHANGING cv_error TYPE string.
  DATA lt_worklist TYPE wa_bsp_worklist.
  CLEAR cv_error.
  IF ps_target-bsp_objkey IS INITIAL.
    cv_error = 'BSP 재개 대상 전체 키가 없습니다.'. RETURN.
  ENDIF.
  SELECT * FROM dwinactiv BYPASSING BUFFER INTO TABLE lt_worklist
    WHERE object = 'WAPP' AND obj_name = ps_target-bsp_objkey.
  PERFORM wa_bsp_resume_owner_check USING ps_target-bsp_objkey lt_worklist CHANGING cv_error.
ENDFORM.

FORM wa_bsp_resume_owner_check USING pv_key TYPE e071-obj_name pt_worklist TYPE wa_bsp_worklist
                              CHANGING cv_error TYPE string.
  DATA ls_work TYPE dwinactiv.
  CLEAR cv_error.
  IF pv_key IS INITIAL OR pt_worklist IS INITIAL.
    cv_error = 'BSP 재개 보류: 선택 WAPP의 전체 키를 미활성 작업 목록에서 확인하지 못했습니다.'. RETURN.
  ENDIF.
  LOOP AT pt_worklist INTO ls_work.
    IF ls_work-object <> 'WAPP' OR ls_work-obj_name <> pv_key.
      cv_error = 'BSP 재개 보류: 미활성 객체 전체 키 불일치'. RETURN.
    ENDIF.
    IF ls_work-uname IS INITIAL OR ls_work-uname <> sy-uname.
      CONCATENATE 'BSP 재개 보류: 미활성 페이지 작성자가 현재 사용자와 다릅니다.' ls_work-uname
        INTO cv_error SEPARATED BY space. RETURN.
    ENDIF.
    IF ls_work-delet_flag IS NOT INITIAL.
      cv_error = 'BSP 재개 보류: 선택 페이지에 미활성 삭제 표시가 있습니다.'. RETURN.
    ENDIF.
  ENDLOOP.
ENDFORM.

FORM wa_bsp_resume_check USING ps_target TYPE wa_target
                        CHANGING cv_detail TYPE string cv_error TYPE string.
  DATA: ls_now TYPE wa_bsp_snapshot, lv_guard TYPE xstring, lv_equal TYPE c,
        lv_compare TYPE string.
  CLEAR: cv_detail, cv_error.
  PERFORM wa_bsp_resume_owner USING ps_target CHANGING cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  PERFORM wa_bsp_fetch_version USING ps_target-bsp_key ps_target-asset-language 'I'
    CHANGING ls_now cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  IF ls_now-app_inactive = 'X'.
    cv_error = 'BSP 재개 보류: 공통 정의 WAPD의 미활성 변경/점검 경고가 있습니다.'. RETURN.
  ENDIF.
  PERFORM wa_bsp_guard USING ls_now CHANGING lv_guard.
  IF lv_guard <> ps_target-bsp_guard.
    cv_error = 'BSP 재개 보류: 미활성 페이지의 Layout 이외 탭/속성이 원본과 다릅니다.'. RETURN.
  ENDIF.
  PERFORM wa_bsp_compare_lines USING ps_target-bsp_expected ls_now-content
    CHANGING lv_equal lv_compare.
  IF lv_equal <> 'X'.
    CONCATENATE 'BSP 재개 보류: 기존 미활성 Layout이 업로드와 다릅니다. 덮어쓰지 않았습니다.'
      lv_compare INTO cv_error SEPARATED BY space. RETURN.
  ENDIF.
  cv_detail = 'REUSE_INACTIVE: 전체 WAPP 키·현재 사용자·GET_VERSION=I·업로드 P_CONTENT·다른 탭 일치 확인; SET_PAGE/SAVE 생략 대상'.
ENDFORM.

FORM wa_bsp_fetch_version USING ps_key TYPE o2pagkey pv_langu TYPE sy-langu pv_version TYPE c
                         CHANGING cs_result TYPE wa_bsp_snapshot cv_error TYPE string.
  DATA: ls_request TYPE wa_bsp_request, lv_nonce TYPE i, lv_program TYPE sy-repid,
        lo_error TYPE REF TO cx_root.
  CLEAR: cs_result, cv_error.
  ADD 1 TO wa_bsp_nonce. ls_request-key = ps_key.
  ls_request-langu = pv_langu. ls_request-nonce = wa_bsp_nonce. ls_request-version = pv_version.
  lv_program = sy-repid.
  FREE MEMORY ID 'Z_PACKAGE_DIAG_BSP_READ'.
  TRY.
      EXPORT request = ls_request TO MEMORY ID 'Z_PACKAGE_DIAG_BSP_READ'.
      SUBMIT (lv_program) WITH p_bspr = 'X' WITH p_pack = p_pack
        WITH p_pkgm = p_pkgm WITH p_bspm = p_bspm WITH p_bsp = p_bsp
        WITH p_file = p_file AND RETURN.
      IMPORT result = cs_result nonce = lv_nonce FROM MEMORY ID 'Z_PACKAGE_DIAG_BSP_READ'.
      IF sy-subrc <> 0 OR lv_nonce <> ls_request-nonce.
        cv_error = 'BSP fresh-session read did not return a matching result'.
      ELSE. cv_error = cs_result-error.
      ENDIF.
    CATCH cx_root INTO lo_error. cv_error = lo_error->get_text( ).
  ENDTRY.
  FREE MEMORY ID 'Z_PACKAGE_DIAG_BSP_READ'.
ENDFORM.

FORM wa_method_contract USING pv_class TYPE string pv_method TYPE string
                              pv_static TYPE c pv_spec TYPE string
                        CHANGING cv_error TYPE string.
  DATA: lo_type TYPE REF TO cl_abap_typedescr, lo_descr TYPE REF TO cl_abap_objectdescr,
        ls_method TYPE abap_methdescr, ls_param TYPE abap_parmdescr,
        lt_specs TYPE ty_lines, lv_spec TYPE string, lv_name TYPE string,
        lv_kind TYPE string, lv_found TYPE c, lo_error TYPE REF TO cx_root.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  TRY.
      CALL METHOD cl_abap_typedescr=>describe_by_name EXPORTING p_name = pv_class
        RECEIVING p_descr_ref = lo_type EXCEPTIONS OTHERS = 1.
      IF sy-subrc <> 0 OR lo_type IS INITIAL.
        CONCATENATE 'BSP_API_CLASS_MISSING' pv_class INTO cv_error SEPARATED BY space. RETURN.
      ENDIF.
      lo_descr ?= lo_type.
      READ TABLE lo_descr->methods INTO ls_method WITH KEY name = pv_method.
      IF sy-subrc <> 0 OR ls_method-is_class <> pv_static OR
         ls_method-visibility <> cl_abap_objectdescr=>public.
        CONCATENATE 'BSP_API_METHOD_MISMATCH' pv_class pv_method INTO cv_error SEPARATED BY space. RETURN.
      ENDIF.
      SPLIT pv_spec AT space INTO TABLE lt_specs.
      LOOP AT lt_specs INTO lv_spec.
        IF lv_spec IS INITIAL. CONTINUE. ENDIF.
        SPLIT lv_spec AT ':' INTO lv_kind lv_name.
        READ TABLE ls_method-parameters INTO ls_param WITH KEY name = lv_name.
        IF sy-subrc <> 0 OR ls_param-parm_kind <> lv_kind.
          CONCATENATE 'BSP_API_PARAMETER' pv_class pv_method lv_spec INTO cv_error SEPARATED BY space. RETURN.
        ENDIF.
      ENDLOOP.
      LOOP AT ls_method-parameters INTO ls_param.
        IF ls_param-is_optional IS INITIAL AND
           ( ls_param-parm_kind = 'I' OR ls_param-parm_kind = 'C' ).
          CLEAR lv_found.
          LOOP AT lt_specs INTO lv_spec.
            SPLIT lv_spec AT ':' INTO lv_kind lv_name.
            IF lv_name = ls_param-name AND lv_kind = ls_param-parm_kind. lv_found = 'X'. ENDIF.
          ENDLOOP.
          IF lv_found IS INITIAL.
            CONCATENATE 'BSP_API_REQUIRED' pv_class pv_method ls_param-name INTO cv_error SEPARATED BY space. RETURN.
          ENDIF.
        ENDIF.
      ENDLOOP.
    CATCH cx_root INTO lo_error. cv_error = lo_error->get_text( ).
  ENDTRY.
ENDFORM.

FORM wa_method_table USING pv_class TYPE string pv_method TYPE string
                           pv_parameter TYPE string
                     CHANGING cr_data TYPE REF TO data cv_error TYPE string.
  DATA: lo_type TYPE REF TO cl_abap_typedescr,
        lo_descr TYPE REF TO cl_abap_objectdescr,
        lo_data TYPE REF TO cl_abap_datadescr, lo_error TYPE REF TO cx_root,
        lo_table TYPE REF TO cl_abap_tabledescr, lo_line TYPE REF TO cl_abap_datadescr,
        lr_line TYPE REF TO data, lv_stage TYPE string, lv_detail TYPE string.
  FIELD-SYMBOLS <ls_line> TYPE ANY.
  CLEAR: cr_data, cv_error.
  TRY.
      lv_stage = 'CLASS'.
      CALL METHOD cl_abap_typedescr=>describe_by_name
        EXPORTING p_name = pv_class RECEIVING p_descr_ref = lo_type
        EXCEPTIONS OTHERS = 1.
      IF sy-subrc <> 0 OR lo_type IS INITIAL.
        cv_error = 'BSP result API class unavailable'.
        PERFORM wa_bsp_type_error USING pv_class pv_method pv_parameter lv_stage CHANGING cv_error.
        RETURN.
      ENDIF.
      lo_descr ?= lo_type.
      lv_stage = 'PARAMETER'.
      CALL METHOD lo_descr->get_method_parameter_type
        EXPORTING p_method_name = pv_method p_parameter_name = pv_parameter
        RECEIVING p_descr_ref = lo_data EXCEPTIONS OTHERS = 1.
      IF sy-subrc <> 0 OR lo_data IS INITIAL.
        cv_error = 'BSP result parameter type unavailable'.
        PERFORM wa_bsp_type_error USING pv_class pv_method pv_parameter lv_stage CHANGING cv_error.
        RETURN.
      ENDIF.
      IF lo_data->type_kind <> cl_abap_typedescr=>typekind_table.
        cv_error = 'BSP result parameter is not an internal table'.
        PERFORM wa_bsp_type_error USING pv_class pv_method pv_parameter lv_stage CHANGING cv_error.
        RETURN.
      ENDIF.
* Preserve fully specified table kind/key whenever it can be instantiated.
      lv_stage = 'TABLE_CREATE'.
      TRY.
          CREATE DATA cr_data TYPE HANDLE lo_data.
        CATCH cx_sy_create_data_error INTO lo_error.
          CLEAR cr_data. lv_detail = lo_error->get_text( ).
      ENDTRY.
      IF cr_data IS INITIAL.
        lo_table ?= lo_data.
* Only generic standard/index/any table shells may be completed as STANDARD.
* Never replace an explicit sorted/hashed key with an invented default key.
        IF lo_table->table_kind <> cl_abap_tabledescr=>tablekind_std AND
           lo_table->table_kind <> cl_abap_tabledescr=>tablekind_index AND
           lo_table->table_kind <> cl_abap_tabledescr=>tablekind_any.
          cv_error = lv_detail.
          PERFORM wa_bsp_type_error USING pv_class pv_method pv_parameter lv_stage CHANGING cv_error.
          RETURN.
        ENDIF.
        lv_stage = 'CONCRETE_LINE'.
        lo_line = lo_table->get_table_line_type( ).
        CREATE DATA lr_line TYPE HANDLE lo_line.
        ASSIGN lr_line->* TO <ls_line>.
        IF sy-subrc <> 0.
          cv_error = 'BSP result line cannot be assigned'.
          PERFORM wa_bsp_type_error USING pv_class pv_method pv_parameter lv_stage CHANGING cv_error.
          RETURN.
        ENDIF.
* LIKE uses the actual installed row structure, including all deep fields.
        lv_stage = 'CONCRETE_TABLE'.
        CREATE DATA cr_data LIKE STANDARD TABLE OF <ls_line> WITH DEFAULT KEY.
      ENDIF.
    CATCH cx_root INTO lo_error.
      CLEAR cr_data. cv_error = lo_error->get_text( ).
      PERFORM wa_bsp_type_error USING pv_class pv_method pv_parameter lv_stage CHANGING cv_error.
  ENDTRY.
ENDFORM.

FORM wa_bsp_type_error USING pv_class TYPE csequence pv_method TYPE csequence
                            pv_parameter TYPE csequence pv_stage TYPE csequence
                      CHANGING cv_error TYPE string.
  CONCATENATE 'BSP_API_TYPE' pv_class pv_method pv_parameter pv_stage ':' cv_error
    INTO cv_error SEPARATED BY space.
ENDFORM.

FORM wa_bsp_message USING ps_message TYPE ANY
                   CHANGING cv_severity TYPE c cv_text TYPE string cv_error TYPE string.
  DATA: lv_line TYPE string, lv_head TYPE string, lv_id TYPE string, lv_number TYPE string.
  FIELD-SYMBOLS: <lv_value> TYPE ANY, <lt_text> TYPE ANY TABLE,
                 <lv_line> TYPE ANY, <ls_id> TYPE ANY.
  CLEAR: cv_severity, cv_text, cv_error.
  ASSIGN COMPONENT 'MTYPE' OF STRUCTURE ps_message TO <lv_value>.
  IF sy-subrc <> 0.
    cv_error = 'BSP activation message has no severity field'. RETURN.
  ENDIF.
  lv_head = <lv_value>.
  IF lv_head <> 'S' AND lv_head <> 'I' AND lv_head <> 'W' AND
     lv_head <> 'E' AND lv_head <> 'A' AND lv_head <> 'X'.
    cv_error = 'BSP activation message has an unknown severity'. RETURN.
  ENDIF.
  cv_severity = lv_head.
  ASSIGN COMPONENT 'MTEXT' OF STRUCTURE ps_message TO <lt_text>.
  IF sy-subrc <> 0.
    cv_error = 'BSP activation message text table unavailable'. RETURN.
  ENDIF.
  LOOP AT <lt_text> ASSIGNING <lv_line>.
    lv_line = <lv_line>.
    IF cv_text IS INITIAL. cv_text = lv_line.
    ELSE. CONCATENATE cv_text lv_line INTO cv_text SEPARATED BY space.
    ENDIF.
  ENDLOOP.
  IF cv_text IS INITIAL.
    ASSIGN COMPONENT 'MESSAGE' OF STRUCTURE ps_message TO <ls_id>.
    IF sy-subrc = 0.
      ASSIGN COMPONENT 'MSGID' OF STRUCTURE <ls_id> TO <lv_value>.
      IF sy-subrc = 0. lv_id = <lv_value>. ENDIF.
      ASSIGN COMPONENT 'MSGNO' OF STRUCTURE <ls_id> TO <lv_value>.
      IF sy-subrc = 0. lv_number = <lv_value>. ENDIF.
      CONCATENATE lv_id lv_number INTO cv_text SEPARATED BY space.
      CONDENSE cv_text.
    ENDIF.
    IF cv_text IS INITIAL. cv_text = 'BSP activation message without text'. ENDIF.
  ENDIF.
  ASSIGN COMPONENT 'OBJECT_TEXT' OF STRUCTURE ps_message TO <lv_value>.
  IF sy-subrc = 0 AND <lv_value> IS NOT INITIAL.
    lv_head = <lv_value>.
    CONCATENATE lv_head cv_text INTO cv_text SEPARATED BY space.
  ENDIF.
ENDFORM.

FORM wa_bsp_exception USING po_error TYPE REF TO cx_root pv_stage TYPE csequence
                     CHANGING cv_error TYPE string.
  DATA: lo_error TYPE REF TO cx_root, lo_type TYPE REF TO cl_abap_typedescr,
        lv_class TYPE string, lv_text TYPE string, lv_detail TYPE string,
        lv_program TYPE sy-repid, lv_include TYPE sy-repid, lv_line TYPE i,
        lv_line_text TYPE c LENGTH 12, lv_index TYPE c LENGTH 3.
  CLEAR cv_error. lo_error = po_error.
* A dynamic-check exception may be wrapped at a procedure boundary. Keep
* the original cause and position, not only the outer "not handled" text.
  DO 8 TIMES.
    IF lo_error IS INITIAL. EXIT. ENDIF.
    WRITE sy-index TO lv_index NO-GROUPING. CONDENSE lv_index.
    CLEAR: lv_class, lv_text, lv_program, lv_include, lv_line, lv_line_text.
    TRY.
        lv_text = lo_error->get_text( ).
        lo_type = cl_abap_typedescr=>describe_by_object_ref( lo_error ).
        lv_class = lo_type->absolute_name.
        CALL METHOD lo_error->get_source_position
          IMPORTING program_name = lv_program include_name = lv_include source_line = lv_line.
      CATCH cx_root.
* Diagnostic enrichment must not replace the original failure.
    ENDTRY.
    IF lv_text IS INITIAL. lv_text = 'Exception detail unavailable'. ENDIF.
    WRITE lv_line TO lv_line_text NO-GROUPING. CONDENSE lv_line_text.
    CONCATENATE '#' lv_index lv_class 'program=' lv_program 'include=' lv_include
      'line=' lv_line_text lv_text INTO lv_detail SEPARATED BY space.
    IF cv_error IS INITIAL.
      CONCATENATE 'BSP' pv_stage ':' lv_detail INTO cv_error SEPARATED BY space.
    ELSE.
      CONCATENATE cv_error cl_abap_char_utilities=>newline lv_detail
        INTO cv_error RESPECTING BLANKS.
    ENDIF.
    lo_error = lo_error->previous.
  ENDDO.
  IF lo_error IS NOT INITIAL.
    CONCATENATE cv_error '[further exception causes omitted]' INTO cv_error SEPARATED BY space.
  ENDIF.
  IF cv_error IS INITIAL.
    CONCATENATE 'BSP' pv_stage ': exception detail unavailable' INTO cv_error SEPARATED BY space.
  ENDIF.
ENDFORM.

FORM wa_bsp_checklist_ref CHANGING cr_ref TYPE REF TO data cv_error TYPE string.
  DATA: lv_class TYPE string, lo_error TYPE REF TO cx_root.
  CLEAR cr_ref.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
* Check the active formal type before SAVE, and again at the call boundary.
  PERFORM wa_fm_contract USING 'RS_WORKING_OBJECTS_ACTIVATE'
    'I:ACTIVATE_DDIC_OBJECTS I:WITH_POPUP E:P_CHECKLIST:CL_WB_CHECKLIST T:OBJECTS:DWINACTIV'
    CHANGING cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  TRY.
      lv_class = 'CL_WB_CHECKLIST'.
* This creates a reference VARIABLE of the exact class type, not an object
* instance and not REF TO object. Keep its type through an ANY field symbol.
      CREATE DATA cr_ref TYPE REF TO (lv_class).
    CATCH cx_root INTO lo_error.
      CLEAR cr_ref.
      PERFORM wa_bsp_exception USING lo_error 'CHECKLIST_REF' CHANGING cv_error.
  ENDTRY.
ENDFORM.

FORM wa_bsp_api_check CHANGING cv_error TYPE string.
  DATA: lr_messages TYPE REF TO data, lr_checklist TYPE REF TO data.
  CLEAR cv_error.
  PERFORM wa_method_contract USING 'CL_O2_API_PAGES' 'SET_PAGE' space 'I:P_CONTENT' CHANGING cv_error.
  PERFORM wa_method_contract USING 'CL_O2_API_PAGES' 'SAVE' space 'I:P_WITH_ALL_TEXTS' CHANGING cv_error.
  PERFORM wa_method_contract USING 'CL_O2_API_APPLICATION' 'SET_CHANGEABLE' space
    'I:P_CHANGEABLE I:P_COMPLETE_APPLICATION' CHANGING cv_error.
  PERFORM wa_method_contract USING 'CL_WB_OBJECT_TYPE' 'GET_CONCATENATED_KEY_FROM_ID' 'X'
    'I:P_KEY_COMPONENT1 I:P_KEY_COMPONENT2 I:P_EXTERNAL_ID' CHANGING cv_error.
  PERFORM wa_fm_contract USING 'RS_CORR_INSERT'
    'I:OBJECT I:OBJECT_CLASS I:DEVCLASS I:KORRNUM I:GLOBAL_LOCK I:SUPPRESS_DIALOG E:KORRNUM E:DEVCLASS'
    CHANGING cv_error.
  PERFORM wa_fm_contract USING 'RS_INACTIVE_OBJECTS_WARNING'
    'I:SUPPRESS_PROTOCOL I:WITH_PROGRAM_INCLUDES I:SUPPRESS_DICTIONARY_CHECK T:P_E071:E071 T:P_XMSG:SPROT_U'
    CHANGING cv_error.
  PERFORM wa_bsp_checklist_ref CHANGING lr_checklist cv_error.
  PERFORM wa_method_contract USING 'CL_WB_CHECKLIST' 'GET_ERROR_MESSAGES' space
    'E:P_ERROR_TAB' CHANGING cv_error.
  IF cv_error IS INITIAL.
    PERFORM wa_method_table USING 'CL_WB_CHECKLIST' 'GET_ERROR_MESSAGES' 'P_ERROR_TAB'
      CHANGING lr_messages cv_error.
  ENDIF.
ENDFORM.

FORM wa_bsp_object_key USING ps_key TYPE o2pagkey CHANGING cv_key TYPE e071-obj_name cv_error TYPE string.
  DATA: lo_type TYPE REF TO cl_abap_typedescr, lo_descr TYPE REF TO cl_abap_objectdescr,
        lo_data TYPE REF TO cl_abap_datadescr, ls_method TYPE abap_methdescr,
        ls_param TYPE abap_parmdescr, lt_bind TYPE abap_parmbind_tab,
        ls_bind TYPE abap_parmbind, lr_result TYPE REF TO data,
        lv_class TYPE string, lv_method TYPE string, lv_text TYPE string,
        ls_key TYPE o2pagkey, lv_external_id TYPE c LENGTH 3,
        lv_parameter TYPE string, lv_stage TYPE string, lv_kind TYPE c,
        lt_ex TYPE abap_excpbind_tab, ls_ex TYPE abap_excpbind, lo_error TYPE REF TO cx_root.
  FIELD-SYMBOLS <lv_value> TYPE ANY.
  CLEAR: cv_key, cv_error.
  ls_key = ps_key. lv_external_id = 'WG '.
  lv_class = 'CL_WB_OBJECT_TYPE'. lv_method = 'GET_CONCATENATED_KEY_FROM_ID'.
  TRY.
      lv_stage = 'CLASS'.
      CALL METHOD cl_abap_typedescr=>describe_by_name EXPORTING p_name = lv_class
        RECEIVING p_descr_ref = lo_type EXCEPTIONS OTHERS = 1.
      IF sy-subrc <> 0. cv_error = 'BSP object key formatter unavailable'. RETURN. ENDIF.
      lo_descr ?= lo_type.
      READ TABLE lo_descr->methods INTO ls_method WITH KEY name = lv_method.
      IF sy-subrc <> 0. cv_error = 'BSP object key formatter method unavailable'. RETURN. ENDIF.
      LOOP AT ls_method-parameters INTO ls_param.
        IF ls_param-name <> 'P_KEY_COMPONENT1' AND ls_param-name <> 'P_KEY_COMPONENT2' AND
           ls_param-name <> 'P_EXTERNAL_ID' AND ls_param-parm_kind <> 'R'. CONTINUE. ENDIF.
        CLEAR ls_bind.
        lv_parameter = ls_param-name. lv_stage = 'BIND_INPUT'.
        ls_bind-name = ls_param-name. ls_bind-kind = 'E'.
* P_KEY_COMPONENT1/2 are generic formal parameters. Bind concrete O2 keys;
* never try to instantiate their ANY/C/CLIKE parameter descriptors.
        CASE ls_param-name.
          WHEN 'P_KEY_COMPONENT1'. GET REFERENCE OF ls_key-applname INTO ls_bind-value.
          WHEN 'P_KEY_COMPONENT2'. GET REFERENCE OF ls_key-pagekey INTO ls_bind-value.
          WHEN 'P_EXTERNAL_ID'. GET REFERENCE OF lv_external_id INTO ls_bind-value.
          WHEN OTHERS.
* A RETURNING parameter is fully typed. Retain that exact type/length.
            lv_stage = 'RETURN_TYPE'.
            CALL METHOD lo_descr->get_method_parameter_type
              EXPORTING p_method_name = lv_method p_parameter_name = ls_param-name
              RECEIVING p_descr_ref = lo_data EXCEPTIONS OTHERS = 1.
            IF sy-subrc <> 0 OR lo_data IS INITIAL.
              cv_error = 'BSP key return parameter type unavailable'.
              PERFORM wa_bsp_type_error USING lv_class lv_method lv_parameter lv_stage CHANGING cv_error.
              RETURN.
            ENDIF.
            CREATE DATA ls_bind-value TYPE HANDLE lo_data.
            ASSIGN ls_bind-value->* TO <lv_value>.
            DESCRIBE FIELD <lv_value> TYPE lv_kind.
            IF lv_kind <> 'C' AND lv_kind <> 'g'.
              cv_error = 'BSP key return parameter is not character-like'.
              PERFORM wa_bsp_type_error USING lv_class lv_method lv_parameter lv_stage CHANGING cv_error.
              RETURN.
            ENDIF.
            ls_bind-kind = 'R'. lr_result = ls_bind-value.
        ENDCASE.
        INSERT ls_bind INTO TABLE lt_bind.
      ENDLOOP.
      IF lr_result IS INITIAL. cv_error = 'BSP object key formatter has no return value'. RETURN. ENDIF.
      ls_ex-name = 'OTHERS'. ls_ex-value = 1. INSERT ls_ex INTO TABLE lt_ex.
      lv_stage = 'CALL_KEY_API'. CLEAR lv_parameter.
      CALL METHOD (lv_class)=>(lv_method) PARAMETER-TABLE lt_bind EXCEPTION-TABLE lt_ex.
      IF sy-subrc <> 0.
        cv_error = 'BSP object key formatter failed'.
        PERFORM wa_bsp_type_error USING lv_class lv_method lv_parameter lv_stage CHANGING cv_error.
        RETURN.
      ENDIF.
      ASSIGN lr_result->* TO <lv_value>. lv_text = <lv_value>. cv_key = lv_text.
      IF cv_key IS INITIAL OR cv_key <> lv_text.
        cv_error = 'BSP WAPP key empty/truncated'.
        CLEAR cv_key.
      ENDIF.
    CATCH cx_root INTO lo_error.
      CLEAR cv_key. cv_error = lo_error->get_text( ).
      PERFORM wa_bsp_type_error USING lv_class lv_method lv_parameter lv_stage CHANGING cv_error.
  ENDTRY.
ENDFORM.

FORM wa_bsp_page_kind USING pv_type TYPE c
                     CHANGING cv_layout TYPE c cv_text TYPE string.
* SAP BSP PAGETYPE: blank = flow-logic page, V = view, X = fragment.
* H/F were incorrect assumptions. Blank is valid only with verified identity.
  CLEAR: cv_layout, cv_text.
  CASE pv_type.
    WHEN space. cv_layout = 'X'. cv_text = 'Flow Logic [SPACE]'.
    WHEN 'V'. cv_layout = 'X'. cv_text = 'View [V]'.
    WHEN 'X'. cv_layout = 'X'. cv_text = 'Fragment [X]'.
    WHEN OTHERS.
      CONCATENATE '지원하지 않는 유형 [' pv_type ']' INTO cv_text.
  ENDCASE.
ENDFORM.

FORM wa_bsp_property_error USING pv_field TYPE csequence
                                pv_actual TYPE csequence pv_expected TYPE csequence
                          CHANGING cv_error TYPE string.
  DATA: lv_actual TYPE string, lv_expected TYPE string.
  lv_actual = pv_actual. lv_expected = pv_expected.
  IF lv_actual IS INITIAL. lv_actual = '<공백/누락>'. ENDIF.
  IF lv_expected IS INITIAL. lv_expected = '<공백>'. ENDIF.
  CONCATENATE 'BSP Properties' pv_field '불일치: 실제=' lv_actual
    '/ 기대=' lv_expected INTO cv_error SEPARATED BY space.
ENDFORM.

FORM wa_bsp_properties_check USING ps_key TYPE o2pagkey pv_lang TYPE sy-langu
                                  ps_attrs TYPE o2pagattr ps_expected TYPE o2pagkey
                                  pv_expected_lang TYPE sy-langu
                            CHANGING cv_error TYPE string.
  DATA: lv_ok TYPE c, lv_text TYPE string.
  CLEAR cv_error.
  IF ps_expected-applname IS INITIAL OR ps_expected-pagekey IS INITIAL OR
     pv_expected_lang IS INITIAL.
    cv_error = 'BSP Properties 검증 대상의 키/언어가 없습니다.'. RETURN.
  ENDIF.
  IF ps_key-applname <> ps_expected-applname.
    PERFORM wa_bsp_property_error USING 'PAGE_KEY/APPLNAME' ps_key-applname
      ps_expected-applname CHANGING cv_error. RETURN.
  ENDIF.
  IF ps_key-pagekey <> ps_expected-pagekey.
    PERFORM wa_bsp_property_error USING 'PAGE_KEY/PAGEKEY' ps_key-pagekey
      ps_expected-pagekey CHANGING cv_error. RETURN.
  ENDIF.
  IF pv_lang <> pv_expected_lang.
    PERFORM wa_bsp_property_error USING 'REQUESTED_LANGUAGE' pv_lang
      pv_expected_lang CHANGING cv_error. RETURN.
  ENDIF.
* Missing PROPERTIES must not become an allowed blank PAGETYPE.
* The API structure must independently identify the same existing page.
  IF ps_attrs-applname <> ps_expected-applname.
    PERFORM wa_bsp_property_error USING 'PROPERTIES/APPLNAME' ps_attrs-applname
      ps_expected-applname CHANGING cv_error. RETURN.
  ENDIF.
  IF ps_attrs-pagekey <> ps_expected-pagekey.
    PERFORM wa_bsp_property_error USING 'PROPERTIES/PAGEKEY' ps_attrs-pagekey
      ps_expected-pagekey CHANGING cv_error. RETURN.
  ENDIF.
  PERFORM wa_bsp_page_kind USING ps_attrs-pagetype CHANGING lv_ok lv_text.
  IF lv_ok <> 'X'.
    CONCATENATE 'BSP Properties/PAGETYPE:' lv_text
      '; 허용=SPACE(Flow Logic), V(View), X(Fragment)' INTO cv_error SEPARATED BY space.
  ENDIF.
ENDFORM.

FORM wa_bsp_prepare CHANGING cs_row TYPE im_result.
  DATA: ls_target TYPE wa_target, ls_asset TYPE ty_web_asset, ls_current TYPE ty_web_asset,
        ls_file TYPE ty_file, ls_live TYPE ty_file, ls_other TYPE ty_file,
        lv_a TYPE xstring, lv_b TYPE xstring, lv_c TYPE xstring,
        lv_ao TYPE c, lv_bo TYPE c, lv_co TYPE c, lv_raw TYPE xstring,
        lv_error TYPE string, lv_text TYPE string, lv_text_a TYPE string,
        lv_text_b TYPE string, lv_text_c TYPE string, lv_path TYPE string,
        lv_root TYPE string, lv_leaf TYPE string, lv_n TYPE i, lv_count TYPE i,
        lt_paths TYPE ty_bsp_paths, ls_path TYPE ty_bsp_path,
        lv_app TYPE o2applname, ls_key TYPE o2pagkey, lv_lang TYPE sy-langu,
        ls_attrs TYPE o2pagattr, ls_now TYPE o2pagattr, lv_equal TYPE c, lv_candidate TYPE c,
        lv_kind_ok TYPE c, lv_kind_text TYPE string,
        lo_error TYPE REF TO cx_root.
  cs_row-wa_save = 'NOT_RUN'. cs_row-wa_activate = 'NOT_RUN'.
  cs_row-wa_inactive = 'NOT_CHECKED'.
  IF p_mime <> 'X'. cs_row-wa_note = '웹자산 모드에서 BSP Layout 반영 조건을 점검합니다.'. RETURN. ENDIF.
  IF wa_catalog_error IS NOT INITIAL. cs_row-wa_note = wa_catalog_error. RETURN. ENDIF.
  TRY.
      READ TABLE im_manifest_index INTO ls_target-file WITH TABLE KEY path = cs_row-path.
      IF sy-subrc <> 0 OR ls_target-file-object <> 'WAPA' OR
         ls_target-file-component <> 'BSP_LAYOUT' OR ls_target-file-check_mode <> 'RAW'.
        cs_row-wa_note = '기존 WAPA/BSP_LAYOUT 원본 매핑이 없습니다.'. RETURN.
      ENDIF.
      cs_row-wa_app = ls_target-file-obj_name.
      READ TABLE wa_assets_a INTO ls_asset WITH KEY content_path = cs_row-path.
      IF sy-subrc = 0.
        cs_row-wa_page = ls_asset-component. cs_row-wa_url = ls_asset-original_path.
        cs_row-wa_lang = ls_asset-language. cs_row-wa_mime = 'BSP Layout'.
      ENDIF.
      PERFORM im_triplet USING ls_target-file CHANGING lv_a lv_b lv_c lv_ao lv_bo lv_co.
      IF lv_ao = 'X'. PERFORM wa_bsp_normalize USING lv_a CHANGING lv_text_a lv_error. ENDIF.
      IF lv_error IS INITIAL AND lv_bo = 'X'. PERFORM wa_bsp_normalize USING lv_b CHANGING lv_text_b lv_error. ENDIF.
      IF lv_error IS INITIAL AND lv_co = 'X'. PERFORM wa_bsp_normalize USING lv_c CHANGING lv_text_c lv_error. ENDIF.
      IF lv_error IS NOT INITIAL. cs_row-wa_note = lv_error. RETURN. ENDIF.
      PERFORM wa_bsp_gate USING lv_ao lv_bo lv_co lv_text_a lv_text_b lv_text_c
        CHANGING lv_candidate cs_row-wa_state cs_row-wa_note.
      IF lv_candidate <> 'X'. RETURN. ENDIF.
      LOOP AT wa_assets_a INTO ls_asset WHERE content_path = cs_row-path.
        ADD 1 TO lv_count. ls_target-asset = ls_asset.
      ENDLOOP.
      IF lv_count <> 1. cs_row-wa_note = '원본 BSP 카탈로그 매핑이 유일하지 않습니다.'. RETURN. ENDIF.
      ls_asset = ls_target-asset. CLEAR lv_count.
      LOOP AT gt_web_assets INTO ls_current WHERE content_path = cs_row-path. ADD 1 TO lv_count. ENDLOOP.
      IF lv_count <> 1. cs_row-wa_note = '현재 BSP 카탈로그 매핑이 유일하지 않습니다.'. RETURN. ENDIF.
      READ TABLE im_current_index INTO ls_live WITH TABLE KEY path = cs_row-path.
      IF sy-subrc <> 0 OR ls_live-object <> 'WAPA' OR ls_live-component <> 'BSP_LAYOUT' OR
         ls_live-obj_name <> ls_target-file-obj_name OR ls_live-devclass <> ls_target-file-devclass OR
         ls_live-language <> ls_target-file-language OR ls_live-check_mode <> 'RAW'.
        cs_row-wa_note = '원본/현재 BSP manifest 식별자가 다릅니다.'. RETURN.
      ENDIF.
      IF ls_asset-object <> 'WAPA' OR ls_asset-kind <> 'BSP_PAGE' OR ls_asset-status <> 'EXPORTED' OR
         ls_asset-obj_name <> ls_target-file-obj_name OR ls_asset-devclass <> ls_target-file-devclass OR
         ls_asset-language <> ls_target-file-language OR ls_asset-active_state <> 'A' OR
         ls_current-object <> ls_asset-object OR ls_current-kind <> ls_asset-kind OR
         ls_current-status <> 'EXPORTED' OR ls_current-obj_name <> ls_asset-obj_name OR
         ls_current-devclass <> ls_asset-devclass OR ls_current-component <> ls_asset-component OR
         ls_current-language <> ls_asset-language OR ls_current-original_path <> ls_asset-original_path OR
         ls_current-metadata_path <> ls_asset-metadata_path.
        cs_row-wa_note = 'BSP 카탈로그의 객체·페이지·언어·경로가 다릅니다.'. RETURN.
      ENDIF.
      READ TABLE gt_seen_pkg WITH TABLE KEY devclass = ls_target-file-devclass TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0 OR cs_row-comparison = 'MAPPING_REJECTED' OR cs_row-comparison = 'OUT_OF_SCOPE'.
        cs_row-wa_note = 'BSP 대상이 선택 패키지 범위 밖입니다.'. RETURN.
      ENDIF.
      ls_target-bsp_key-applname = ls_asset-obj_name. ls_target-bsp_key-pagekey = ls_asset-component.
      IF ls_target-bsp_key-applname <> ls_asset-obj_name OR ls_target-bsp_key-pagekey <> ls_asset-component.
        cs_row-wa_note = 'BSP 내부 키 길이 초과'. RETURN.
      ENDIF.
      cs_row-wa_app = ls_target-bsp_key-applname. cs_row-wa_page = ls_target-bsp_key-pagekey.
      cs_row-wa_url = ls_asset-original_path. cs_row-wa_lang = ls_asset-language.
      cs_row-wa_mime = 'BSP Layout'.
      CLEAR lv_count.
      LOOP AT im_manifest_index INTO ls_file WHERE object = 'WAPA' AND
        obj_name = ls_asset-obj_name AND devclass = ls_asset-devclass AND component = 'BSP_PAGE_PATH_MAP'.
        ADD 1 TO lv_count. ls_target-bsp_map = ls_file-path.
      ENDLOOP.
      IF lv_count <> 1. cs_row-wa_note = 'BSP 페이지 경로 맵이 없거나 중복됩니다.'. RETURN. ENDIF.
      PERFORM wa_metadata USING ls_target-bsp_map CHANGING lv_raw lv_error.
      IF lv_error IS NOT INITIAL. cs_row-wa_note = lv_error. RETURN. ENDIF.
      CALL TRANSFORMATION id SOURCE XML lv_raw RESULT application = lv_app page_paths = lt_paths.
      IF lv_app <> ls_target-bsp_key-applname. cs_row-wa_note = 'BSP 경로 맵 애플리케이션 불일치'. RETURN. ENDIF.
      CLEAR lv_count.
      LOOP AT lt_paths INTO ls_path WHERE pagekey = ls_target-bsp_key-pagekey.
        ADD 1 TO lv_count. ls_target-bsp_path = ls_path.
      ENDLOOP.
      ls_path = ls_target-bsp_path.
      IF lv_count <> 1 OR ls_path-error IS NOT INITIAL OR ls_path-original_name <> ls_asset-original_path OR
         ls_path-read_language <> ls_asset-language OR ls_path-folder IS INITIAL.
        cs_row-wa_note = 'BSP 내부 키·원래 페이지명·실제 언어 매핑 불일치'. RETURN.
      ENDIF.
      lv_n = strlen( ls_target-bsp_map ) - strlen( 'page-paths.xml' ).
      IF lv_n <= 0. cs_row-wa_note = 'BSP 경로 맵 경로 오류'. RETURN. ENDIF.
      lv_root = ls_target-bsp_map(lv_n).
      CONCATENATE lv_root ls_path-folder '/' INTO ls_target-bsp_prefix.
      CONCATENATE ls_target-bsp_prefix 'Properties.xml' INTO lv_path.
      IF lv_path <> ls_asset-metadata_path. cs_row-wa_note = 'BSP Properties 경로 불일치'. RETURN. ENDIF.
      PERFORM web_leaf USING ls_asset-original_path CHANGING lv_leaf.
      CONCATENATE ls_target-bsp_prefix 'Layout/' lv_leaf INTO lv_path.
      IF lv_path <> cs_row-path. cs_row-wa_note = 'BSP Layout 경로 불일치'. RETURN. ENDIF.
      PERFORM wa_metadata USING ls_asset-metadata_path CHANGING lv_raw lv_error.
      IF lv_error IS NOT INITIAL. cs_row-wa_note = lv_error. RETURN. ENDIF.
      CLEAR: ls_key, lv_lang, ls_attrs.
      CALL TRANSFORMATION id SOURCE XML lv_raw RESULT page_key = ls_key requested_language = lv_lang properties = ls_attrs.
      PERFORM wa_bsp_page_kind USING ls_attrs-pagetype CHANGING lv_kind_ok lv_kind_text.
      cs_row-wa_page_type = lv_kind_text.
      PERFORM wa_bsp_properties_check USING ls_key lv_lang ls_attrs
        ls_target-bsp_key ls_asset-language CHANGING lv_error.
      IF lv_error IS NOT INITIAL. cs_row-wa_note = lv_error. RETURN. ENDIF.
      PERFORM wa_bsp_companions USING ls_target CHANGING lv_error.
      IF lv_error IS NOT INITIAL. cs_row-wa_note = lv_error. RETURN. ENDIF.
      ls_target-before = lv_c. ls_target-wanted = lv_b.
      PERFORM wa_bsp_api_check CHANGING lv_error.
      IF lv_error IS INITIAL.
        PERFORM wa_bsp_object_key USING ls_target-bsp_key CHANGING ls_target-bsp_objkey lv_error.
      ENDIF.
      IF lv_error IS INITIAL.
        PERFORM wa_bsp_fetch USING ls_target-bsp_key ls_asset-language CHANGING ls_target-bsp_snapshot lv_error.
      ENDIF.
      cs_row-wa_inactive_detail = ls_target-bsp_snapshot-inactive_detail.
      IF lv_error IS NOT INITIAL.
        cs_row-wa_inactive = 'CHECK_FAILED'. cs_row-wa_note = lv_error. RETURN.
      ENDIF.
      PERFORM wa_bsp_pending_note USING ls_target-bsp_key ls_target-bsp_snapshot
        CHANGING cs_row-wa_inactive lv_error.
      IF ls_target-bsp_snapshot-app_inactive = 'X'. cs_row-wa_note = lv_error. RETURN. ENDIF.
      IF lv_error IS NOT INITIAL. ls_target-bsp_resume = 'X'. CLEAR lv_error. ENDIF.
      ls_now = ls_target-bsp_snapshot-attrs.
      PERFORM wa_bsp_clear_generated CHANGING ls_attrs.
      PERFORM wa_bsp_clear_generated CHANGING ls_now.
      IF ls_attrs <> ls_now. cs_row-wa_note = 'Export 이후 BSP 페이지 속성이 변경되었습니다.'. RETURN. ENDIF.
      PERFORM wa_bsp_equal USING lv_c ls_target-bsp_snapshot-layout CHANGING lv_equal lv_error.
      IF lv_error IS NOT INITIAL OR lv_equal <> 'X'.
        cs_row-wa_note = '진단 도중 BSP 활성 Layout이 변경되었거나 읽기 검증에 실패했습니다.'. RETURN.
      ENDIF.
* Resolve Export representation against all active API rows before any write.
* Keep original A/B/C bytes for conflicts and backups; only SET_PAGE receives
* the proven editing representation.
      PERFORM wa_bsp_export_content USING lv_a lv_b ls_target-bsp_snapshot-content
        CHANGING ls_target-bsp_expected cs_row-wa_verify_detail lv_error.
      IF lv_error IS NOT INITIAL. cs_row-wa_note = lv_error. RETURN. ENDIF.
      PERFORM wa_bsp_guard USING ls_target-bsp_snapshot CHANGING ls_target-bsp_guard.
      IF ls_target-bsp_resume = 'X'.
        PERFORM wa_bsp_resume_check USING ls_target CHANGING lv_text lv_error.
        CONCATENATE cs_row-wa_verify_detail cl_abap_char_utilities=>newline lv_text lv_error
          INTO cs_row-wa_verify_detail RESPECTING BLANKS.
        IF lv_error IS NOT INITIAL. cs_row-wa_note = lv_error. RETURN. ENDIF.
        cs_row-wa_inactive = 'RESUME_VERIFIED'.
      ENDIF.
      ls_target-id = cs_row-id. ls_target-eligible = 'X'.
      ls_target-bsp_save = 'NOT_RUN'. ls_target-bsp_activate = 'NOT_RUN'.
      APPEND ls_target TO wa_targets.
      cs_row-wa_ready = 'X'. cs_row-wa_state = 'READY'.
      cs_row-wa_note = 'BSP Layout 저장 후보: 다른 탭 보존·페이지 활성화·활성 소스 재검증 대상.'.
      IF ls_target-bsp_resume = 'X'.
        cs_row-wa_state = 'READY_ACTIVATE'.
        cs_row-wa_note = '기존 미활성 Layout이 업로드와 일치: 저장 생략·해당 WAPP 활성화 재개 후보. 실행 전 CTS·잠금·내용 재검증.'.
      ENDIF.
    CATCH cx_root INTO lo_error.
      cs_row-wa_note = lo_error->get_text( ). CLEAR cs_row-wa_ready. cs_row-wa_state = 'BLOCKED'.
  ENDTRY.
ENDFORM.

FORM wa_bsp_companions USING ps_target TYPE wa_target CHANGING cv_error TYPE string.
  DATA: ls_file TYPE ty_file, ls_row TYPE im_result, lv_a TYPE xstring, lv_b TYPE xstring,
        lv_c TYPE xstring, lv_ao TYPE c, lv_bo TYPE c, lv_co TYPE c,
        lv_n TYPE i, lv_attrs TYPE i, lv_types TYPE i.
  CLEAR cv_error. lv_n = strlen( ps_target-bsp_prefix ).
  LOOP AT im_manifest_index INTO ls_file.
    IF strlen( ls_file-path ) < lv_n. CONTINUE. ENDIF.
    IF ls_file-path(lv_n) <> ps_target-bsp_prefix OR ls_file-path = ps_target-file-path. CONTINUE. ENDIF.
    IF ls_file-object <> 'WAPA' OR ls_file-obj_name <> ps_target-file-obj_name OR
       ls_file-devclass <> ps_target-file-devclass OR ls_file-language <> ps_target-file-language.
      cv_error = 'BSP 동반 파일의 객체·패키지·언어 불일치'. RETURN.
    ENDIF.
    IF ls_file-component = 'BSP_ATTRIBUTES'. CONTINUE. ENDIF.
    IF ls_file-component <> 'BSP_PARAMETERS' AND ls_file-component <> 'BSP_EVENT_SOURCE' AND
       ls_file-component <> 'BSP_TYPE_SOURCE'.
      cv_error = '같은 BSP 페이지에 알 수 없는 구성요소가 있습니다.'. RETURN.
    ENDIF.
    IF ls_file-component = 'BSP_PARAMETERS'. ADD 1 TO lv_attrs. ENDIF.
    IF ls_file-component = 'BSP_TYPE_SOURCE'. ADD 1 TO lv_types. ENDIF.
    PERFORM im_triplet USING ls_file CHANGING lv_a lv_b lv_c lv_ao lv_bo lv_co.
    IF lv_ao <> 'X' OR lv_bo <> 'X' OR lv_co <> 'X' OR lv_a <> lv_b OR lv_a <> lv_c.
      CONCATENATE 'Layout 이외 탭의 변경/누락:' ls_file-path INTO cv_error SEPARATED BY space. RETURN.
    ENDIF.
  ENDLOOP.
  IF lv_attrs <> 1 OR lv_types <> 1.
    cv_error = 'BSP Page Attributes/Type Definitions 원본이 완전하지 않습니다.'. RETURN.
  ENDIF.
* Also reject new unmanifested files and current-only events under this page.
  LOOP AT im_results INTO ls_row.
    IF strlen( ls_row-path ) < lv_n. CONTINUE. ENDIF.
    IF ls_row-path(lv_n) <> ps_target-bsp_prefix OR ls_row-path = ps_target-file-path. CONTINUE. ENDIF.
    READ TABLE im_manifest_index WITH TABLE KEY path = ls_row-path TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0. cv_error = '같은 BSP 페이지에 원본에 없던 동반 파일이 있습니다.'. RETURN. ENDIF.
  ENDLOOP.
ENDFORM.

FORM wa_backup_payload USING pv_path TYPE string CHANGING cv_raw TYPE xstring cv_error TYPE string.
  DATA: ls_file TYPE ty_file, lv_b TYPE xstring, lv_c TYPE xstring,
        lv_ao TYPE c, lv_bo TYPE c, lv_co TYPE c.
  READ TABLE im_manifest_index INTO ls_file WITH TABLE KEY path = pv_path.
  IF sy-subrc <> 0. cv_error = 'Backup manifest entry missing'. RETURN. ENDIF.
  IF ls_file-component = 'BSP_PARAMETERS' OR ls_file-component = 'BSP_EVENT_SOURCE' OR
     ls_file-component = 'BSP_TYPE_SOURCE'.
    PERFORM im_triplet USING ls_file CHANGING cv_raw lv_b lv_c lv_ao lv_bo lv_co.
    IF lv_ao <> 'X' OR lv_bo <> 'X' OR cv_raw <> lv_b.
      cv_error = 'Backup BSP companion changed or unreadable'.
    ENDIF.
  ELSE.
    PERFORM wa_metadata USING pv_path CHANGING cv_raw cv_error.
  ENDIF.
ENDFORM.

FORM wa_bsp_read USING pv_after TYPE c CHANGING cs_target TYPE wa_target
                                              cv_raw TYPE xstring cv_error TYPE string.
  DATA: ls_now TYPE wa_bsp_snapshot, lv_guard TYPE xstring, lv_pending TYPE c LENGTH 16,
        lv_detail TYPE string.
  CLEAR: cv_raw, cv_error.
  PERFORM wa_authority USING cs_target CHANGING cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  PERFORM wa_bsp_fetch USING cs_target-bsp_key cs_target-asset-language CHANGING ls_now cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  cv_raw = ls_now-layout.
  IF ls_now-attrs-applname <> cs_target-bsp_key-applname OR
     ls_now-attrs-pagekey <> cs_target-bsp_key-pagekey OR
     ls_now-attrs-pagename <> cs_target-asset-original_path.
    cv_error = 'BSP live page identity changed'. RETURN.
  ENDIF.
  PERFORM wa_bsp_guard USING ls_now CHANGING lv_guard.
  IF lv_guard <> cs_target-bsp_guard.
    cv_error = 'BSP Layout 이외 탭 또는 애플리케이션 속성이 변경되었습니다.'. RETURN.
  ENDIF.
  IF pv_after IS INITIAL.
    IF cs_target-bsp_resume = 'X'.
      IF ls_now-app_inactive = 'X'.
        cv_error = 'BSP 재개 직전 공통 정의 WAPD 미활성/점검 경고'. RETURN.
      ENDIF.
      PERFORM wa_bsp_resume_check USING cs_target CHANGING lv_detail cv_error.
    ELSE.
      PERFORM wa_bsp_pending_note USING cs_target-bsp_key ls_now CHANGING lv_pending cv_error.
    ENDIF.
    IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  ENDIF.
ENDFORM.

FORM wa_bsp_lock USING pv_lock TYPE c CHANGING cs_target TYPE wa_target cv_error TYPE string.
  DATA: ls_app TYPE wa_bsp_app, lv_method TYPE string, lv_rc TYPE sysubrc,
        lo_error TYPE REF TO cx_root.
  FIELD-SYMBOLS <ls_app> TYPE wa_bsp_app.
  CLEAR cv_error. lv_method = 'SET_CHANGEABLE'.
  TRY.
      READ TABLE wa_bsp_apps ASSIGNING <ls_app> WITH KEY name = cs_target-bsp_key-applname.
      IF pv_lock = 'X'.
        IF cs_target-locked = 'X'. RETURN. ENDIF.
        IF sy-subrc = 0.
          ADD 1 TO <ls_app>-holders. cs_target-locked = 'X'. RETURN.
        ENDIF.
        ls_app-name = cs_target-bsp_key-applname.
        CALL METHOD cl_o2_api_application=>load EXPORTING p_application_name = ls_app-name
          IMPORTING p_application = ls_app-api EXCEPTIONS OTHERS = 1.
        IF sy-subrc <> 0 OR ls_app-api IS INITIAL. cv_error = 'BSP lock application LOAD failed'. RETURN. ENDIF.
        CALL METHOD ls_app-api->(lv_method)
          EXPORTING p_changeable = 'X' p_complete_application = 'X' EXCEPTIONS OTHERS = 1.
        lv_rc = sy-subrc.
        IF lv_rc <> 0.
          PERFORM wa_api_error USING 'BSP SET_CHANGEABLE' lv_rc CHANGING cv_error. RETURN.
        ENDIF.
        ls_app-holders = 1. APPEND ls_app TO wa_bsp_apps. cs_target-locked = 'X'.
      ELSE.
        IF cs_target-locked IS INITIAL. RETURN. ENDIF.
        IF sy-subrc <> 0 OR <ls_app>-api IS INITIAL.
          cv_error = 'BSP acquired lock handle is missing'. RETURN.
        ENDIF.
        IF <ls_app>-holders > 1.
          SUBTRACT 1 FROM <ls_app>-holders. CLEAR cs_target-locked. RETURN.
        ENDIF.
        CALL METHOD <ls_app>-api->(lv_method)
          EXPORTING p_changeable = space p_complete_application = 'X' EXCEPTIONS OTHERS = 1.
        lv_rc = sy-subrc.
        IF lv_rc <> 0.
          PERFORM wa_api_error USING 'BSP release change mode' lv_rc CHANGING cv_error. RETURN.
        ENDIF.
        DELETE wa_bsp_apps WHERE name = cs_target-bsp_key-applname. CLEAR cs_target-locked.
      ENDIF.
    CATCH cx_root INTO lo_error. cv_error = lo_error->get_text( ).
  ENDTRY.
ENDFORM.

FORM wa_bsp_context USING ps_target TYPE wa_target CHANGING cv_error TYPE string.
  CLEAR cv_error.
  PERFORM wa_scope_check USING ps_target CHANGING cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  IF p_mime <> 'X' OR im_screen_mode <> 'M' OR wa_busy <> 'X' OR
     ps_target-selected <> 'X' OR ps_target-eligible <> 'X' OR ps_target-locked <> 'X' OR
     wa_backup IS INITIAL OR wa_journal_owned <> 'X' OR
     ps_target-file-object <> 'WAPA' OR ps_target-file-component <> 'BSP_LAYOUT' OR
     ps_target-file-check_mode <> 'RAW' OR ps_target-asset-kind <> 'BSP_PAGE' OR
     ps_target-bsp_key IS INITIAL OR ps_target-bsp_objkey IS INITIAL OR
     ps_target-bsp_expected IS INITIAL OR ps_target-bsp_guard IS INITIAL.
    cv_error = 'BSP_WRITE_CONTEXT_REJECTED'. RETURN.
  ENDIF.
  READ TABLE wa_bsp_apps WITH KEY name = ps_target-bsp_key-applname TRANSPORTING NO FIELDS.
  IF sy-subrc <> 0. cv_error = 'BSP_WRITE_LOCK_HANDLE_MISSING'. ENDIF.
ENDFORM.

FORM wa_bsp_cts CHANGING cs_target TYPE wa_target cv_error TYPE string.
  DATA: lv_fm TYPE rs38l-name, lv_task TYPE e070-trkorr,
        lv_package TYPE tadir-devclass, lv_rc TYPE sysubrc.
  PERFORM wa_bsp_context USING cs_target CHANGING cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  IF cs_target-file-devclass <> '$TMP'. lv_task = p_task. ENDIF.
  lv_fm = 'RS_CORR_INSERT'.
* WAPP uses SAP's key formatter. No guessed filename or manual concatenation.
  CALL FUNCTION lv_fm EXPORTING object = cs_target-bsp_objkey object_class = 'WAPP'
    devclass = cs_target-file-devclass korrnum = lv_task global_lock = 'X' suppress_dialog = 'X'
    IMPORTING korrnum = cs_target-task devclass = lv_package
    EXCEPTIONS error_message = 1 OTHERS = 2.
  lv_rc = sy-subrc.
  IF lv_rc <> 0. PERFORM wa_api_error USING 'BSP CTS insert WAPP' lv_rc CHANGING cv_error. RETURN. ENDIF.
  IF lv_package <> cs_target-file-devclass. cv_error = 'BSP CTS returned a different package'. RETURN. ENDIF.
  PERFORM wa_bsp_cts_verify USING cs_target CHANGING cv_error.
ENDFORM.

FORM wa_bsp_cts_verify USING ps_target TYPE wa_target CHANGING cv_error TYPE string.
  DATA lv_task TYPE e071-trkorr.
  CLEAR cv_error.
  IF ps_target-file-devclass = '$TMP'. RETURN. ENDIF.
  IF ps_target-task IS INITIAL OR ps_target-task <> p_task.
    cv_error = 'BSP CTS returned a different task'. RETURN.
  ENDIF.
  SELECT SINGLE trkorr FROM e071 INTO lv_task WHERE trkorr = ps_target-task
    AND pgmid = 'LIMU' AND object = 'WAPP' AND obj_name = ps_target-bsp_objkey.
  IF sy-subrc <> 0.
    cv_error = 'CTS 작업에서 해당 LIMU WAPP 페이지 등록을 확인하지 못했습니다.'.
  ENDIF.
ENDFORM.

FORM wa_bsp_save CHANGING cs_target TYPE wa_target cv_error TYPE string.
  DATA: lo_page TYPE REF TO cl_o2_api_pages, ls_snapshot TYPE wa_bsp_snapshot,
        lv_method TYPE string, lv_version TYPE ty_bsp_version, lv_raw TYPE xstring,
        lv_equal TYPE c, lv_rc TYPE sysubrc.
  PERFORM wa_bsp_context USING cs_target CHANGING cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  IF cs_target-bsp_resume IS NOT INITIAL.
    cv_error = 'BSP 재개 대상에는 SET_PAGE/SAVE를 실행할 수 없습니다.'. RETURN.
  ENDIF.
  CALL METHOD cl_o2_api_pages=>load EXPORTING p_pagekey = cs_target-bsp_key p_version = 'A'
    p_langu = cs_target-asset-language p_with_all_texts = space p_load_for_generation = space
    IMPORTING p_page = lo_page EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0 OR lo_page IS INITIAL. cv_error = 'BSP write LOAD failed'. RETURN. ENDIF.
  lv_version = lo_page->get_version( ).
  IF lv_version <> 'A'. cv_error = 'BSP write handle is not the active version'. RETURN. ENDIF.
  CALL METHOD lo_page->get_page IMPORTING p_xml_source = lv_raw p_content = ls_snapshot-content EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0. cv_error = 'BSP write handle GET_PAGE failed'. RETURN. ENDIF.
  IF lv_raw IS NOT INITIAL.
    PERFORM wa_bsp_equal USING lv_raw cs_target-before CHANGING lv_equal cv_error.
    IF cv_error IS NOT INITIAL OR lv_equal <> 'X'. cv_error = 'BSP write handle contains stale Layout'. RETURN. ENDIF.
  ENDIF.
* Check the loaded handle's other tabs too; an old cached API object must
* never silently replace freshly verified server attributes/events/types.
  ls_snapshot-app_attrs = cs_target-bsp_snapshot-app_attrs.
  CALL METHOD lo_page->get_attrs IMPORTING p_attrs = ls_snapshot-attrs EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0. cv_error = 'BSP write GET_ATTRS failed'. RETURN. ENDIF.
  CALL METHOD lo_page->get_event_handlers IMPORTING p_ev_handler = ls_snapshot-events EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0. cv_error = 'BSP write GET_EVENT_HANDLERS failed'. RETURN. ENDIF.
  CALL METHOD lo_page->get_parameters IMPORTING p_parameters = ls_snapshot-parameters EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0. cv_error = 'BSP write GET_PARAMETERS failed'. RETURN. ENDIF.
  CALL METHOD lo_page->get_type_source IMPORTING p_source = ls_snapshot-types EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0. cv_error = 'BSP write GET_TYPE_SOURCE failed'. RETURN. ENDIF.
  PERFORM wa_bsp_guard USING ls_snapshot CHANGING lv_raw.
  IF lv_raw <> cs_target-bsp_guard. cv_error = 'BSP write handle contains stale non-Layout tabs'. RETURN. ENDIF.
  lv_method = 'SET_PAGE'.
  CALL METHOD lo_page->(lv_method) EXPORTING p_content = cs_target-bsp_expected EXCEPTIONS OTHERS = 1.
  lv_rc = sy-subrc.
  IF lv_rc <> 0. PERFORM wa_api_error USING 'BSP SET_PAGE' lv_rc CHANGING cv_error. RETURN. ENDIF.
* Detect an API input mismatch before SAVE; repository checks still use a fresh session.
  CLEAR: ls_snapshot-content, ls_snapshot-layout.
  CALL METHOD lo_page->get_page IMPORTING p_content = ls_snapshot-content
    p_xml_source = ls_snapshot-layout EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0. cv_error = 'BSP SET_PAGE readback GET_PAGE failed'. RETURN. ENDIF.
  PERFORM wa_bsp_check_layout USING cs_target ls_snapshot 'SET_PAGE_READBACK'
    CHANGING lv_equal cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
* Never call SET_ATTRS/SET_PARAMETERS/SET_EVENT_HANDLERS/SET_TYPE_SOURCE.
  lv_method = 'SAVE'. cs_target-bsp_save = 'SAVE_ATTEMPT'.
  CALL METHOD lo_page->(lv_method) EXPORTING p_with_all_texts = space EXCEPTIONS OTHERS = 1.
  lv_rc = sy-subrc.
  IF lv_rc <> 0. PERFORM wa_api_error USING 'BSP SAVE' lv_rc CHANGING cv_error. RETURN. ENDIF.
  cs_target-bsp_save = 'SAVE_RETURNED'.
ENDFORM.

FORM wa_bsp_saved_check CHANGING cs_target TYPE wa_target cv_error TYPE string.
  DATA: ls_now TYPE wa_bsp_snapshot, lv_raw TYPE xstring, lv_equal TYPE c,
        lv_detail TYPE string, lv_page_protocol TYPE c LENGTH 7,
        lv_app_protocol TYPE c LENGTH 7.
  IF cs_target-bsp_resume = 'X'.
    PERFORM wa_bsp_resume_owner USING cs_target CHANGING cv_error.
    IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  ENDIF.
  PERFORM wa_bsp_fetch_version USING cs_target-bsp_key cs_target-asset-language 'I'
    CHANGING ls_now cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  PERFORM wa_bsp_guard USING ls_now CHANGING lv_raw.
  IF lv_raw <> cs_target-bsp_guard. cv_error = '저장된 미활성 BSP의 다른 탭이 원래 상태와 다릅니다.'. RETURN. ENDIF.
  PERFORM wa_bsp_check_layout USING cs_target ls_now 'SAVED_INACTIVE_CHECK'
    CHANGING lv_equal cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
* Fresh LOAD(I), GET_VERSION=I, native Layout and non-Layout equality prove
* the saved version. An empty warning protocol is not proof of its absence.
* Keep this verified save state even if a later activation guard rejects it.
  cs_target-bsp_save = 'SAVED_INACTIVE'.
  IF cs_target-bsp_resume = 'X'. cs_target-bsp_save = 'REUSED_INACTIVE'. ENDIF.
  PERFORM wa_bsp_status USING cs_target.
  lv_page_protocol = 'NONE'. lv_app_protocol = 'NONE'.
  READ TABLE ls_now-inactive WITH TABLE KEY applname = cs_target-bsp_key-applname
    pagekey = cs_target-bsp_key-pagekey TRANSPORTING NO FIELDS.
  IF sy-subrc = 0. lv_page_protocol = 'PRESENT'. ENDIF.
  IF ls_now-app_inactive = 'X'. lv_app_protocol = 'PRESENT'. ENDIF.
  CONCATENATE 'I 버전 재조회·Layout·다른 탭 검증 완료; WAPP_PROTOCOL='
    lv_page_protocol '; WAPD_PROTOCOL=' lv_app_protocol INTO lv_detail.
  PERFORM wa_bsp_verify_record USING cs_target 'SAVED_INACTIVE_STATE' 'VERIFIED' lv_detail.
  PERFORM wa_event_add USING cs_target-id cs_target-file-path
    'SAVED_INACTIVE_PROTOCOL' 'EVIDENCE' ls_now-inactive_detail.
  IF ls_now-app_inactive = 'X'.
    cv_error = '활성화 직전 공통 정의 WAPD 점검 경고가 있습니다. 다른 HTM 변경과 별도 확인 필요.'.
  ENDIF.
ENDFORM.

FORM wa_bsp_activate CHANGING cs_target TYPE wa_target cv_error TYPE string.
  DATA: lt_objects TYPE STANDARD TABLE OF dwinactiv, ls_object TYPE dwinactiv,
        lv_fm TYPE rs38l-name, lv_rc TYPE sysubrc, lv_optional TYPE fupararef-parameter,
        lo_checklist TYPE REF TO object, lr_checklist TYPE REF TO data, lr_messages TYPE REF TO data,
        lv_message TYPE string, lv_severity TYPE c, lv_message_error TYPE string,
        lv_method TYPE string, lv_stage TYPE c LENGTH 24, lv_detail TYPE string,
        lo_error TYPE REF TO cx_root.
  FIELD-SYMBOLS: <lt_messages> TYPE ANY TABLE, <ls_message> TYPE ANY, <lo_checklist> TYPE ANY.
  PERFORM wa_bsp_context USING cs_target CHANGING cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  TRY.
  lv_stage = 'CHECKLIST_REF'.
  PERFORM wa_bsp_checklist_ref CHANGING lr_checklist cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  ASSIGN lr_checklist->* TO <lo_checklist>.
  IF sy-subrc <> 0. cv_error = 'BSP P_CHECKLIST reference variable cannot be assigned'. RETURN. ENDIF.
* Resolve the installed result table before activation, without a static DDIC alias.
  lv_stage = 'CHECKLIST_TABLE'.
  PERFORM wa_method_table USING 'CL_WB_CHECKLIST' 'GET_ERROR_MESSAGES' 'P_ERROR_TAB'
    CHANGING lr_messages cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  ASSIGN lr_messages->* TO <lt_messages>.
  IF sy-subrc <> 0. cv_error = 'BSP activation result is not an internal table'. RETURN. ENDIF.
  lv_stage = 'ACTIVATE_RECHECK'.
  PERFORM wa_bsp_saved_check CHANGING cs_target cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  lv_stage = 'ACTIVATE_CTS'.
  PERFORM wa_bsp_cts_verify USING cs_target CHANGING cv_error.
  IF cv_error IS NOT INITIAL. RETURN. ENDIF.
  ls_object-object = 'WAPP'. ls_object-obj_name = cs_target-bsp_objkey.
  APPEND ls_object TO lt_objects. lv_fm = 'RS_WORKING_OBJECTS_ACTIVATE'.
* Single page only, never a WAPA/application mass activation or DDIC list.
  SELECT SINGLE parameter FROM fupararef INTO lv_optional WHERE funcname = lv_fm
    AND r3state = 'A' AND paramtype = 'I' AND parameter = 'UI_DECOUPLED'.
  lv_stage = 'ACTIVATE_CALL'. cs_target-bsp_phase = lv_stage.
  cs_target-bsp_activate = 'ACTIVATE_ATTEMPT'.
  lv_detail = 'RS_WORKING_OBJECTS_ACTIVATE: P_CHECKLIST=REF TO CL_WB_CHECKLIST; OBJECTS=one WAPP; DDIC=off'.
  PERFORM wa_bsp_verify_record USING cs_target 'ACTIVATION_CALL' 'ATTEMPT' lv_detail.
  IF lv_optional = 'UI_DECOUPLED'.
    CALL FUNCTION lv_fm EXPORTING activate_ddic_objects = space with_popup = space ui_decoupled = 'X'
      IMPORTING p_checklist = <lo_checklist> TABLES objects = lt_objects
      EXCEPTIONS error_message = 1 OTHERS = 2.
  ELSE.
    CALL FUNCTION lv_fm EXPORTING activate_ddic_objects = space with_popup = space
      IMPORTING p_checklist = <lo_checklist> TABLES objects = lt_objects
      EXCEPTIONS error_message = 1 OTHERS = 2.
  ENDIF.
  lv_rc = sy-subrc.
  IF lv_rc <> 0. PERFORM wa_api_error USING 'BSP page activation' lv_rc CHANGING cv_error. ENDIF.
  lv_stage = 'ACTIVATE_RETURN'. cs_target-bsp_phase = lv_stage.
  lv_detail = '활성화 함수 반환. 체크리스트 및 활성 소스 검증 전 상태입니다.'.
  PERFORM wa_bsp_verify_record USING cs_target 'ACTIVATION_CALL' 'RETURNED' lv_detail.
* The generic reference is only for method dispatch after the typed FM output.
  lo_checklist = <lo_checklist>.
  IF lo_checklist IS NOT INITIAL.
    lv_stage = 'CHECKLIST_READ'. cs_target-bsp_phase = lv_stage.
    lv_method = 'GET_ERROR_MESSAGES'.
    CALL METHOD lo_checklist->(lv_method) IMPORTING p_error_tab = <lt_messages> EXCEPTIONS OTHERS = 1.
    IF sy-subrc <> 0. cv_error = 'BSP activation checklist could not be read'.
    ELSE.
      lv_stage = 'CHECKLIST_MESSAGES'. cs_target-bsp_phase = lv_stage.
      LOOP AT <lt_messages> ASSIGNING <ls_message>.
        PERFORM wa_bsp_message USING <ls_message>
          CHANGING lv_severity lv_message lv_message_error.
        IF lv_message_error IS NOT INITIAL.
          cv_error = lv_message_error. EXIT.
        ENDIF.
        PERFORM wa_event_add USING cs_target-id cs_target-file-path 'ACTIVATION_MESSAGE' lv_severity lv_message.
        IF lv_severity = 'E' OR lv_severity = 'A' OR lv_severity = 'X'.
          IF cv_error IS INITIAL. cv_error = lv_message. ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
  LOOP AT lt_objects INTO ls_object.
    IF ls_object-object <> 'WAPP' OR ls_object-obj_name <> cs_target-bsp_objkey.
      cv_error = '활성화 API의 처리 목록이 선택한 BSP 페이지를 벗어났습니다. SAP 확인 필요.'. EXIT.
    ENDIF.
  ENDLOOP.
  IF cv_error IS INITIAL. cs_target-bsp_activate = 'ACTIVATE_RETURNED'. ENDIF.
    CATCH cx_root INTO lo_error.
      PERFORM wa_bsp_exception USING lo_error lv_stage CHANGING lv_detail.
      IF cv_error IS INITIAL. cv_error = lv_detail.
      ELSE. CONCATENATE cv_error lv_detail INTO cv_error SEPARATED BY space.
      ENDIF.
      PERFORM wa_bsp_verify_record USING cs_target 'ACTIVATION_EXCEPTION' 'ERROR' lv_detail.
  ENDTRY.
ENDFORM.

FORM wa_bsp_status USING ps_target TYPE wa_target.
  FIELD-SYMBOLS <ls_row> TYPE im_result.
  READ TABLE im_results ASSIGNING <ls_row> WITH KEY id = ps_target-id.
  IF sy-subrc = 0.
    <ls_row>-wa_save = ps_target-bsp_save. <ls_row>-wa_activate = ps_target-bsp_activate.
  ENDIF.
ENDFORM.

FORM wa_bsp_one CHANGING cs_target TYPE wa_target cv_error TYPE string.
  DATA: lv_raw TYPE xstring, lv_error TYPE string, lv_detail TYPE string,
        lv_attempt TYPE c, lv_equal TYPE c, lv_after TYPE i, lv_state TYPE c LENGTH 24,
        ls_now TYPE wa_bsp_snapshot, lo_error TYPE REF TO cx_root,
        lv_pending TYPE c LENGTH 16.
  CLEAR cv_error.
  TRY.
      PERFORM wa_bsp_context USING cs_target CHANGING cv_error.
      IF cv_error IS INITIAL. PERFORM wa_bsp_read USING space CHANGING cs_target lv_raw cv_error. ENDIF.
      IF cv_error IS INITIAL AND lv_raw <> cs_target-before.
        cv_error = '저장 직전 BSP 활성 소스가 진단 시점과 다릅니다.'.
      ENDIF.
      IF cv_error IS INITIAL.
        cs_target-bsp_phase = 'BEFORE_SAVE'.
        lv_detail = 'BSP Layout 저장 전: 백업 완료, 다른 탭 보존, 단일 페이지 활성화 예정.'.
        IF cs_target-bsp_resume = 'X'.
          cs_target-bsp_phase = 'BEFORE_RESUME'.
          lv_detail = 'BSP 활성화 재개 전: 기존 I=업로드 검증, SET_PAGE/SAVE 생략, 기존 CTS 등록 확인 예정.'.
        ENDIF.
        PERFORM wa_set_result USING cs_target-id 'WRITE_INTENT' lv_detail '@09@' 0 cs_target-task.
        PERFORM wa_event_add USING cs_target-id cs_target-file-path cs_target-bsp_phase 'WRITE_INTENT' lv_detail.
        PERFORM wa_flush CHANGING cv_error.
      ENDIF.
      IF cv_error IS INITIAL.
        lv_attempt = 'X'. wa_touched = 'X'.
        IF cs_target-bsp_resume = 'X'.
* Existing inactive content must already belong to the supplied task. Do not
* insert/move it into a different CTS task merely to make resume possible.
          IF cs_target-file-devclass <> '$TMP'. cs_target-task = p_task. ENDIF.
          PERFORM wa_bsp_cts_verify USING cs_target CHANGING cv_error.
          IF cv_error IS INITIAL.
            PERFORM wa_bsp_resume_check USING cs_target CHANGING lv_detail cv_error.
          ENDIF.
          IF cv_error IS INITIAL.
            cs_target-bsp_save = 'REUSED_INACTIVE'.
            PERFORM wa_bsp_verify_record USING cs_target 'REUSE_INACTIVE' 'VERIFIED' lv_detail.
          ENDIF.
        ELSE.
          PERFORM wa_bsp_cts CHANGING cs_target cv_error.
          IF cv_error IS INITIAL. PERFORM wa_bsp_save CHANGING cs_target cv_error. ENDIF.
          IF cv_error IS INITIAL.
            COMMIT WORK AND WAIT.
            IF sy-subrc <> 0. cv_error = 'BSP SAVE commit failed'. ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
      IF cv_error IS INITIAL. PERFORM wa_bsp_saved_check CHANGING cs_target cv_error. ENDIF.
      IF cv_error IS INITIAL.
        cs_target-bsp_phase = 'BEFORE_ACTIVATE'.
        PERFORM wa_bsp_status USING cs_target.
        lv_detail = '미활성 Layout 저장·재조회 확인. 다른 탭 동일. 해당 WAPP 한 페이지 활성화 직전.'.
        IF cs_target-bsp_resume = 'X'.
          lv_detail = '기존 미활성 Layout 재사용·CTS·다른 탭 검증 완료. 저장 생략. 해당 WAPP 한 페이지 활성화 직전.'.
        ENDIF.
        PERFORM wa_set_result USING cs_target-id cs_target-bsp_save lv_detail '@09@' 0 cs_target-task.
        PERFORM wa_event_add USING cs_target-id cs_target-file-path 'BEFORE_ACTIVATE' cs_target-bsp_save lv_detail.
        PERFORM wa_flush CHANGING cv_error.
      ENDIF.
      IF cv_error IS INITIAL. PERFORM wa_bsp_activate CHANGING cs_target cv_error. ENDIF.
      IF cv_error IS INITIAL.
        COMMIT WORK AND WAIT.
        IF sy-subrc <> 0. cv_error = 'BSP activation commit failed'. ENDIF.
      ENDIF.
      IF cv_error IS NOT INITIAL AND lv_attempt = 'X'. ROLLBACK WORK. ENDIF.
    CATCH cx_root INTO lo_error.
      cv_error = lo_error->get_text( ).
      IF lv_attempt = 'X'. ROLLBACK WORK. ENDIF.
  ENDTRY.
* Do not mask an earlier error with a later equal read. SAVE/activation can
* commit internally; report observed state and retain the recovery package.
  IF lv_attempt = 'X'.
    CLEAR cs_target-eligible.
    TRY.
        PERFORM wa_bsp_fetch USING cs_target-bsp_key cs_target-asset-language CHANGING ls_now lv_error.
        IF lv_error IS INITIAL.
          lv_after = xstrlen( ls_now-layout ).
          PERFORM wa_bsp_guard USING ls_now CHANGING lv_raw.
          IF lv_raw <> cs_target-bsp_guard. lv_error = '반영 후 다른 BSP 탭/애플리케이션 속성 불일치'. ENDIF.
          IF lv_error IS INITIAL AND cs_target-bsp_activate <> 'NOT_RUN'.
            PERFORM wa_bsp_check_layout USING cs_target ls_now 'ACTIVE_CHECK'
              CHANGING lv_equal lv_error.
          ENDIF.
* If activation was skipped, the unchanged active page is expected, not a second failure.
          IF lv_error IS INITIAL AND cs_target-bsp_activate <> 'NOT_RUN'.
            PERFORM wa_bsp_pending_note USING cs_target-bsp_key ls_now CHANGING lv_pending lv_error.
          ENDIF.
          IF cv_error IS NOT INITIAL OR lv_error IS NOT INITIAL.
            PERFORM wa_bsp_observed USING cs_target ls_now.
          ENDIF.
        ENDIF.
        IF lv_error IS NOT INITIAL.
          CONCATENATE cv_error lv_error INTO cv_error SEPARATED BY space.
        ENDIF.
        IF cv_error IS INITIAL. PERFORM wa_bsp_cts_verify USING cs_target CHANGING cv_error. ENDIF.
      CATCH cx_root INTO lo_error.
        lv_error = lo_error->get_text( ).
        CONCATENATE cv_error 'BSP 재조회 실패:' lv_error INTO cv_error SEPARATED BY space.
    ENDTRY.
  ENDIF.
  IF cv_error IS INITIAL AND lv_attempt = 'X'.
    cs_target-bsp_save = 'VERIFIED'. cs_target-bsp_activate = 'VERIFIED'.
    lv_state = 'ACTIVATED_VERIFIED'.
    lv_detail = 'BSP Layout 저장·페이지 활성화·활성 소스/다른 탭 보존 검증 완료. 실제 화면 실행은 별도 확인.'.
    IF cs_target-bsp_resume = 'X'.
      cs_target-bsp_save = 'REUSED_VERIFIED'.
      lv_detail = '기존 미활성 Layout 재사용·해당 페이지 활성화·활성 소스/다른 탭 보존 검증 완료. 이번 실행의 저장은 생략.'.
    ENDIF.
    PERFORM wa_set_result USING cs_target-id lv_state lv_detail '@08@' lv_after cs_target-task.
  ELSE.
    lv_state = 'FAILED_REVIEW'.
    IF lv_attempt = 'X' AND cs_target-bsp_activate = 'NOT_RUN'.
      CONCATENATE cv_error '활성화는 실행하지 않았습니다.' INTO cv_error SEPARATED BY space.
    ENDIF.
    IF cs_target-bsp_save = 'SAVED_INACTIVE' OR cs_target-bsp_save = 'REUSED_INACTIVE'.
      IF cs_target-bsp_activate = 'NOT_RUN'. lv_state = 'SAVED_NOT_ACTIVATED'.
      ELSE. lv_state = 'ACTIVATION_REVIEW'. cs_target-bsp_activate = 'FAILED_REVIEW'.
      ENDIF.
    ELSEIF lv_attempt = 'X' AND cs_target-bsp_resume IS INITIAL. cs_target-bsp_save = 'FAILED_REVIEW'.
    ENDIF.
    lv_detail = cv_error.
    PERFORM wa_set_result USING cs_target-id lv_state lv_detail '@0A@' lv_after cs_target-task.
  ENDIF.
  PERFORM wa_bsp_status USING cs_target.
  PERFORM wa_event_add USING cs_target-id cs_target-file-path 'BSP_RESULT' lv_state lv_detail.
  PERFORM wa_flush CHANGING lv_error.
  IF lv_error IS NOT INITIAL.
    wa_log_error = lv_error.
    CONCATENATE cv_error '실행 로그 저장 실패:' lv_error INTO cv_error SEPARATED BY space.
    PERFORM wa_set_result USING cs_target-id 'LOG_FAILED_REVIEW' cv_error '@0A@' lv_after cs_target-task.
  ENDIF.
ENDFORM.

FORM wa_bsp_observed USING ps_target TYPE wa_target ps_now TYPE wa_bsp_snapshot.
  DATA: lv_equal TYPE c, lv_error TYPE string, lv_detail TYPE string,
        lv_pending TYPE c LENGTH 16, lv_pending_note TYPE string.
  PERFORM wa_bsp_equal USING ps_now-layout ps_target-before CHANGING lv_equal lv_error.
  IF lv_equal = 'X'. lv_detail = '오류 후 활성 Layout은 저장 전과 동일합니다.'.
  ELSE.
    PERFORM wa_bsp_compare_lines USING ps_target-bsp_expected ps_now-content
      CHANGING lv_equal lv_error.
    IF lv_equal = 'X'. lv_detail = '오류 후 활성 Layout은 업로드와 동일하지만 성공 판정은 보류합니다.'.
    ELSE. lv_detail = '오류 후 활성 Layout은 저장 전/업로드와 모두 다릅니다. 백업 기준 확인 필요.'.
    ENDIF.
  ENDIF.
  PERFORM wa_bsp_pending_note USING ps_target-bsp_key ps_now CHANGING lv_pending lv_pending_note.
  IF lv_pending_note IS NOT INITIAL.
    CONCATENATE lv_detail lv_pending_note INTO lv_detail SEPARATED BY space.
    PERFORM wa_event_add USING ps_target-id ps_target-file-path 'INACTIVE_PROTOCOL' 'REVIEW' ps_now-inactive_detail.
  ENDIF.
  PERFORM wa_bsp_verify_record USING ps_target 'OBSERVED_AFTER_ERROR' 'REVIEW' lv_detail.
ENDFORM.

FORM wa_bsp_gate USING pv_ao TYPE c pv_bo TYPE c pv_co TYPE c
                      pv_a TYPE string pv_b TYPE string pv_c TYPE string
                CHANGING cv_ready TYPE c cv_state TYPE c cv_note TYPE c.
  CLEAR cv_ready. cv_state = 'BLOCKED'.
  IF pv_ao <> 'X' OR pv_bo <> 'X' OR pv_co <> 'X'.
    cv_note = '원본·수정본·SAP 활성 Layout을 모두 읽어야 합니다.'.
  ELSEIF pv_b = pv_c.
    cv_state = 'ALREADY_EQUAL'. cv_note = 'SAP 활성 Layout과 동일: 저장 불필요.'.
  ELSEIF pv_a = pv_b.
    cv_state = 'UPLOAD_UNCHANGED'. cv_note = '업로드 Layout은 원본과 동일: SAP 변경을 되돌리지 않습니다.'.
  ELSEIF pv_a <> pv_c.
    cv_state = 'CONFLICT'. cv_note = 'Export 이후 SAP Layout도 변경되었습니다. 재추출 후 병합하십시오.'.
  ELSE.
* Remaining metadata/API/inactive/companion guards must still pass.
    cv_ready = 'X'. cv_note = 'BSP 저장 후보의 매핑과 미활성 상태를 점검합니다.'.
  ENDIF.
ENDFORM.

FORM scope_url USING pv_app TYPE o2applname
               CHANGING cv_url TYPE string cv_error TYPE string.
  DATA: lv_tail TYPE string, lv_app TYPE string,
        lv_bsp TYPE c, lv_valid TYPE c.
  CLEAR: cv_url, cv_error.
  IF pv_app IS INITIAL.
    cv_error = 'BSP 애플리케이션 이름을 입력하십시오. 예: ZWEB_COMMON'. RETURN.
  ENDIF.
  IF pv_app(1) = '/'.
    lv_tail = pv_app+1.
    CONCATENATE '/SAP/BC/BSP/' lv_tail INTO cv_url.
  ELSE.
    CONCATENATE '/SAP/BC/BSP/SAP/' pv_app INTO cv_url.
  ENDIF.
  PERFORM bsp_app_from_url USING cv_url CHANGING lv_app lv_bsp lv_valid.
  IF lv_valid <> 'X' OR lv_app <> pv_app.
    cv_error = 'BSP 이름 형식 오류: 정확한 애플리케이션 이름 하나를 입력하십시오.'.
  ENDIF.
ENDFORM.

FORM scope_url_check USING pv_url TYPE string CHANGING cv_error TYPE string.
  DATA: lv_app TYPE string, lv_bsp TYPE c, lv_valid TYPE c,
        lv_relative TYPE string.
  CLEAR cv_error.
  IF p_bspm <> 'X'. RETURN. ENDIF.
  PERFORM bsp_app_from_url USING pv_url CHANGING lv_app lv_bsp lv_valid.
  IF lv_valid <> 'X' OR lv_app <> p_bsp.
    cv_error = '선택한 BSP 애플리케이션 밖의 MIME 경로입니다.'. RETURN.
  ENDIF.
  PERFORM bsp_mime_relative USING pv_url p_bsp CHANGING lv_relative cv_error.
ENDFORM.

FORM scope_screen.
  LOOP AT SCREEN.
    IF screen-group1 = 'PKG'.
      IF p_bspm = 'X'. screen-active = 0. ELSE. screen-active = 1. ENDIF.
      MODIFY SCREEN.
    ELSEIF screen-group1 = 'BSP'.
      IF p_bspm = 'X'. screen-active = 1. ELSE. screen-active = 0. ENDIF.
      MODIFY SCREEN.
    ELSEIF screen-group1 = 'RSL'.
      IF p_bspm = 'X'. screen-input = 0. ELSE. screen-input = 1. ENDIF.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ENDFORM.

FORM scope_add_object USING ps_object TYPE ty_object.
  DATA ls_pkg TYPE ty_package.
  READ TABLE gt_objects WITH KEY pgmid = ps_object-pgmid
    object = ps_object-object obj_name = ps_object-obj_name TRANSPORTING NO FIELDS.
  IF sy-subrc = 0. RETURN. ENDIF.
  APPEND ps_object TO gt_objects.
  ls_pkg-devclass = ps_object-devclass.
  INSERT ls_pkg INTO TABLE gt_seen_pkg.
  IF sy-subrc = 0. APPEND ls_pkg TO gt_packages. ENDIF.
ENDFORM.

FORM scope_discover_bsp.
* Only one WAPA and its MIME subtree are enumerated. Owner packages are
* metadata/authorization context, never an instruction to scan a package.
  DATA: ls_app TYPE ty_object, ls_child TYPE ty_object,
        lo_mime TYPE REF TO if_mr_api, lt_files TYPE string_table,
        lt_seen TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line,
        lv_base TYPE string, lv_url TYPE string, lv_error TYPE string,
        ls_io TYPE skwf_io, lv_id TYPE tadir-obj_name,
        lv_folder TYPE boole_d, lv_auth TYPE c, ls_ref TYPE ty_web_ref,
        lo_error TYPE REF TO cx_root.
  gv_stage = 'BSP_SCOPE'.
  PERFORM scope_url USING p_bsp CHANGING lv_base gv_fatal.
  IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
  SELECT SINGLE pgmid object obj_name devclass FROM tadir
    INTO CORRESPONDING FIELDS OF ls_app
    WHERE pgmid = 'R3TR' AND object = 'WAPA' AND obj_name = p_bsp.
  IF sy-subrc <> 0 OR ls_app-devclass IS INITIAL.
    gv_fatal = 'BSP 애플리케이션의 TADIR 등록/개발 패키지를 찾을 수 없습니다.'. RETURN.
  ENDIF.
  PERFORM check_auth USING ls_app-object ls_app-obj_name ls_app-devclass CHANGING lv_auth.
  IF lv_auth <> 'X'. gv_fatal = 'BSP 애플리케이션 조회 권한이 없습니다.'. RETURN. ENDIF.
  gv_scope_package = ls_app-devclass.
  PERFORM scope_add_object USING ls_app.
  PERFORM segment USING p_bsp CHANGING gv_archive_name.
  CONCATENATE gv_archive_name '_export.zip' INTO gv_archive_name.
  TRY.
      lo_mime = cl_mime_repository_api=>get_api( ).
      IF lo_mime IS INITIAL. gv_fatal = 'MIME repository API unavailable'. RETURN. ENDIF.
      CALL METHOD lo_mime->get_io_for_url EXPORTING i_url = lv_base
        IMPORTING e_loio = ls_io e_is_folder = lv_folder
        EXCEPTIONS not_found = 1 OTHERS = 2.
      IF sy-subrc = 1.
* An app with Layout only is a valid BSP scope.
        WRITE: / 'BSP MIME 폴더 없음:', p_bsp. RETURN.
      ELSEIF sy-subrc <> 0 OR lv_folder <> 'X'.
        gv_fatal = 'BSP MIME 폴더 조회 실패: 추출 범위를 확정하지 못했습니다.'. RETURN.
      ENDIF.
      CALL METHOD lo_mime->file_list
        EXPORTING i_url = lv_base i_recursive_call = 'X' i_check_authority = 'X'
        IMPORTING e_files = lt_files EXCEPTIONS OTHERS = 1.
      IF sy-subrc <> 0.
        gv_fatal = 'BSP MIME 목록 조회 실패: 추출 범위를 확정하지 못했습니다.'. RETURN.
      ENDIF.
      APPEND lv_base TO lt_files.
      LOOP AT lt_files INTO lv_url.
        IF lv_url IS INITIAL. CONTINUE. ENDIF.
        IF lv_url(1) <> '/'. CONCATENATE lv_base '/' lv_url INTO lv_url. ENDIF.
        INSERT lv_url INTO TABLE lt_seen.
        IF sy-subrc <> 0. CONTINUE. ENDIF.
        PERFORM scope_url_check USING lv_url CHANGING gv_fatal.
        IF gv_fatal IS NOT INITIAL. RETURN. ENDIF.
        CLEAR: ls_io, lv_folder, ls_child, ls_ref.
        CALL METHOD lo_mime->get_io_for_url EXPORTING i_url = lv_url
          IMPORTING e_loio = ls_io e_is_folder = lv_folder EXCEPTIONS OTHERS = 1.
        IF sy-subrc <> 0 OR ls_io-objid IS INITIAL.
          gv_fatal = 'BSP MIME URL/LOIO 조회 실패: 추출 범위를 확정하지 못했습니다.'. RETURN.
        ENDIF.
        lv_id = ls_io-objid.
        SELECT SINGLE pgmid object obj_name devclass FROM tadir
          INTO CORRESPONDING FIELDS OF ls_child
          WHERE pgmid = 'R3TR' AND object = 'SMIM' AND obj_name = lv_id.
        IF sy-subrc <> 0 OR ls_child-devclass IS INITIAL.
* Folder nodes need not be transport objects. Unowned file bodies are
* excluded explicitly instead of guessing their package/CTS identity.
          IF lv_folder <> 'X'.
            ls_ref-object = 'WAPA'. ls_ref-obj_name = p_bsp.
            ls_ref-component = lv_url. ls_ref-target_object = 'SMIM'.
            ls_ref-target_name = lv_id. ls_ref-scope = 'OWNER_UNRESOLVED'.
            ls_ref-evidence = 'BSP_MIME_TREE_TADIR'. APPEND ls_ref TO gt_web_refs.
            gs_object = ls_app.
            PERFORM log USING 'BSP_SCOPE' 'WARNING'
              'MIME file has no verified TADIR owner; body excluded; see web references'.
          ENDIF.
          CONTINUE.
        ENDIF.
        PERFORM scope_add_object USING ls_child.
      ENDLOOP.
    CATCH cx_root INTO lo_error.
      gv_fatal = lo_error->get_text( ). RETURN.
  ENDTRY.
  SORT gt_packages BY devclass.
  SORT gt_objects BY devclass pgmid object obj_name.
  DESCRIBE TABLE gt_objects LINES gv_count.
  WRITE: / 'BSP 애플리케이션:', p_bsp, / '선택 앱과 소속 MIME 객체:', gv_count.
ENDFORM.

FORM scope_mode.
  p_mb = 512.
  IF p_bspm = 'X'.
    CLEAR: p_pkgm, p_sub.
    TRANSLATE p_bsp TO UPPER CASE.
    gv_scope_kind = 'BSP'.
    CLEAR: p_all, p_src, p_xml. p_mime = 'X'.
  ELSE.
    p_pkgm = 'X'. p_sub = 'X'. gv_scope_kind = 'PACKAGE'.
  ENDIF.
ENDFORM.

FORM scope_selection CHANGING cv_error TYPE string.
  DATA lv_url TYPE string.
  CLEAR cv_error.
  IF p_bspm = 'X'.
    PERFORM scope_url USING p_bsp CHANGING lv_url cv_error.
  ELSEIF p_pack IS INITIAL.
    cv_error = '개발 패키지를 입력하십시오.'.
  ENDIF.
  IF cv_error IS INITIAL AND p_file IS INITIAL.
    cv_error = '비교할 추출본 ZIP 파일을 선택하십시오.'.
  ENDIF.
ENDFORM.

FORM im_scope_file USING ps_file TYPE ty_file CHANGING cv_error TYPE string.
* Path layout may change; real owner and selected app checks remain exact.
  DATA: lv_pkg TYPE string, lv_app TYPE string, lv_root TYPE string,
        lv_mime TYPE string, lv_meta TYPE string, lv_n TYPE i,
        ls_pkg TYPE ty_package.
  CLEAR cv_error.
  IF p_bspm <> 'X'. RETURN. ENDIF.
  IF ps_file-path = 'catalog/web-assets.xml' AND ps_file-component = 'WEB_CATALOG'
     AND ps_file-object IS INITIAL AND ps_file-obj_name IS INITIAL
     AND ps_file-devclass IS INITIAL. RETURN. ENDIF.
  IF gv_bsp_flat = 'X' AND ps_file-path = 'catalog/mime-metadata.xml' AND
     ps_file-component = 'MIME_METADATA' AND ps_file-object IS INITIAL AND
     ps_file-obj_name IS INITIAL AND ps_file-devclass IS INITIAL. RETURN. ENDIF.
  READ TABLE im_packages INTO ls_pkg WITH KEY devclass = ps_file-devclass.
  IF sy-subrc <> 0 OR ps_file-devclass IS INITIAL.
    cv_error = 'BSP_SCOPE_FILE: manifest 소유 패키지 매핑 오류'. RETURN.
  ENDIF.
  PERFORM scope_bsp_root USING im_header-bsp_package im_header-bsp_application
    CHANGING lv_root.
  CONCATENATE lv_root 'MIMEs/' INTO lv_mime.
  IF ps_file-object = 'WAPA' AND ps_file-obj_name = p_bsp AND
     ps_file-devclass = im_header-bsp_package AND ps_file-component CP 'BSP_*'.
    CONCATENATE lv_root 'pages/' INTO lv_root.
    lv_n = strlen( lv_root ).
    IF strlen( ps_file-path ) > lv_n.
      IF ps_file-path(lv_n) = lv_root. RETURN. ENDIF.
    ENDIF.
  ELSEIF ps_file-object = 'SMIM' AND ps_file-obj_name IS NOT INITIAL AND
         ps_file-component = 'MIME_CONTENT' AND ps_file-check_mode = 'RAW'.
    lv_n = strlen( lv_mime ).
    IF strlen( ps_file-path ) > lv_n.
      IF ps_file-path(lv_n) = lv_mime. RETURN. ENDIF.
    ENDIF.
  ELSEIF gv_bsp_flat IS INITIAL AND
         ps_file-component = 'MIME_METADATA' AND ps_file-object IS INITIAL AND
         ps_file-obj_name IS INITIAL.
    PERFORM mime_metadata_path USING ps_file-devclass CHANGING lv_meta.
    IF ps_file-path = lv_meta. RETURN. ENDIF.
  ENDIF.
  cv_error = 'BSP_SCOPE_FILE: 선택 앱 밖의 객체/경로 또는 허용되지 않은 파일 유형'.
ENDFORM.

FORM im_scope_manifest CHANGING cv_error TYPE string.
  DATA: ls_file TYPE ty_file, ls_pkg TYPE ty_package, lv_catalog TYPE c,
        lv_app TYPE c, lv_path TYPE string, lv_raw TYPE xstring.
  CLEAR cv_error.
  IF p_bspm <> 'X'. RETURN. ENDIF.
  READ TABLE im_packages INTO ls_pkg WITH KEY devclass = im_header-bsp_package.
  IF sy-subrc <> 0. cv_error = 'BSP 소유 패키지가 manifest PACKAGES에 없습니다.'. RETURN. ENDIF.
  LOOP AT im_manifest INTO ls_file.
    PERFORM im_scope_file USING ls_file CHANGING cv_error.
    IF cv_error IS NOT INITIAL.
      CONCATENATE cv_error ls_file-path INTO cv_error SEPARATED BY ': '. RETURN.
    ENDIF.
    IF ls_file-path = 'catalog/web-assets.xml'. lv_catalog = 'X'. ENDIF.
    IF ls_file-object = 'WAPA'. lv_app = 'X'. ENDIF.
  ENDLOOP.
* A MIME-only selected rollback may not contain page files. The full
* catalog still supplies identity; no page file is required for restore.
  IF lv_catalog <> 'X'. cv_error = 'BSP 추출본에 웹자산 원본 목록이 없습니다.'. RETURN. ENDIF.
  lv_path = 'catalog/web-assets.xml'.
  PERFORM wa_metadata USING lv_path CHANGING lv_raw cv_error.
ENDFORM.

FORM im_scope_current USING ps_file TYPE ty_file CHANGING cv_in TYPE c.
  DATA lv_error TYPE string.
  CLEAR cv_in.
  PERFORM im_scope_file USING ps_file CHANGING lv_error.
  IF lv_error IS NOT INITIAL. RETURN. ENDIF.
  IF ps_file-component = 'WEB_CATALOG' OR ps_file-component = 'MIME_METADATA'.
    cv_in = 'X'. RETURN.
  ENDIF.
  READ TABLE gt_objects WITH KEY pgmid = 'R3TR' object = ps_file-object
    obj_name = ps_file-obj_name devclass = ps_file-devclass TRANSPORTING NO FIELDS.
  IF sy-subrc = 0. cv_in = 'X'. ENDIF.
ENDFORM.

FORM wa_scope_check USING ps_target TYPE wa_target CHANGING cv_error TYPE string.
  DATA lv_in TYPE c.
  CLEAR cv_error.
  IF p_bspm <> 'X'. RETURN. ENDIF.
  PERFORM im_scope_current USING ps_target-file CHANGING lv_in.
  IF lv_in <> 'X'. cv_error = '반영 대상이 선택한 BSP 범위 밖입니다.'. RETURN. ENDIF.
  CASE ps_target-file-object.
    WHEN 'WAPA'.
      IF ps_target-file-obj_name <> p_bsp OR ps_target-file-component <> 'BSP_LAYOUT' OR
         ps_target-bsp_key-applname <> p_bsp.
        cv_error = '선택한 기존 BSP Layout만 반영할 수 있습니다.'.
      ENDIF.
    WHEN 'SMIM'.
      PERFORM scope_url_check USING ps_target-asset-original_path CHANGING cv_error.
    WHEN OTHERS. cv_error = 'BSP 모드의 반영 유형이 아닙니다.'.
  ENDCASE.
ENDFORM.

FORM scope_bsp_root USING pv_package TYPE c pv_app TYPE c
                    CHANGING cv_root TYPE string.
* Logical paths are relative to manifest.xml. Ownership stays in metadata.
  DATA: lv_pkg TYPE string, lv_app TYPE string.
  CLEAR cv_root.
  IF gv_bsp_flat = 'X'. RETURN. ENDIF.
  PERFORM segment USING pv_package CHANGING lv_pkg.
  PERFORM segment USING pv_app CHANGING lv_app.
  CONCATENATE 'packages/' lv_pkg '/BSP Application/WAPA/' lv_app '/'
    INTO cv_root.
ENDFORM.

FORM scope_zip_path USING pv_path TYPE csequence CHANGING cv_path TYPE string.
* Only the ZIP entry has the enclosing app folder; manifest paths do not.
  DATA lv_app TYPE string.
  cv_path = pv_path.
  IF gv_bsp_flat <> 'X'. RETURN. ENDIF.
  PERFORM segment USING p_bsp CHANGING lv_app.
  CONCATENATE lv_app '/' pv_path INTO cv_path.
ENDFORM.

FORM im_payload_path USING pv_path TYPE string CHANGING cv_ok TYPE c.
  CLEAR cv_ok.
  IF pv_path = 'catalog/web-assets.xml'. cv_ok = 'X'. RETURN. ENDIF.
  IF gv_bsp_flat = 'X'.
    IF pv_path CP 'pages/*' OR pv_path CP 'MIMEs/*' OR
       pv_path = 'catalog/mime-metadata.xml'. cv_ok = 'X'. ENDIF.
  ELSEIF pv_path CP 'packages/*'. cv_ok = 'X'.
  ENDIF.
ENDFORM.
