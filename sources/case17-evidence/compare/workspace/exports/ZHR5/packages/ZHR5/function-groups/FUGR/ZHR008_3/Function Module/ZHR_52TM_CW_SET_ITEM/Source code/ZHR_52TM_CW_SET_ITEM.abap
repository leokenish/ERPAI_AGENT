FUNCTION zhr_52tm_cw_set_item .                                         
*"----------------------------------------------------------------------
*"*"Local interface:                                                    
*"  IMPORTING                                                           
*"     VALUE(I_PERNR) TYPE  PERSNO                                      
*"     VALUE(IS_DATA) TYPE  ZSHR0141                                    
*"     VALUE(TDCOST) TYPE  CHAR1                                        
*"  EXPORTING                                                           
*"     VALUE(E_RETURN) TYPE  BAPIRETURN1                                
*"  CHANGING                                                            
*"     REFERENCE(CS_ZSHR0141) TYPE  ZSHR0141 OPTIONAL                   
*"----------------------------------------------------------------------
  DATA: ls_zthr0112 TYPE zthr0112,                                      
        ls_zthr0132 TYPE zthr0132,                                      
        ls_zshr0143 TYPE zshr0143,                                      
        ls_zshr0139 TYPE zshr0139,                                      
        lv_daytxt TYPE tagbez,                                          
        lv_min TYPE i.                                                  
                                                                        
  CLEAR cs_zshr0141.                                                    
                                                                        
  MOVE-CORRESPONDING is_data TO cs_zshr0141.                            
  cs_zshr0141-pernr = i_pernr.                                          
  cs_zshr0141-waers = 'KRW'.                                            
                                                                        
  "요일                                                                   
  CALL FUNCTION 'RH_GET_DATE_DAYNAME'                                   
    EXPORTING                                                           
      langu  = '3'  "sy-langu                                           
      date   = cs_zshr0141-datum                                        
    IMPORTING                                                           
      daytxt = lv_daytxt.                                               
                                                                        
  cs_zshr0141-zyoil = lv_daytxt+0(1).                                   
                                                                        
  "등급, 단가                                                               
  PERFORM g_cw_get_data USING i_pernr                                   
                              is_data                                   
                        CHANGING ls_zshr0143                            
                                 e_return.                              
  MOVE-CORRESPONDING ls_zshr0143 TO cs_zshr0141.                        
                                                                        
                                                                        
  "ZRLWK_TM(실근로시간), ZPDWK_TM(휴계시간)                                      
  "ZRLNGTWK_TM(야간근로시간), ZRLHOLWK_TM(휴일근로시간)                             
  "ZOVRADD_TM(가산근무시간)                                                   
  PERFORM d_cw_get_data USING i_pernr                                   
                              is_data                                   
                        CHANGING ls_zshr0139                            
                                 e_return.                              
  MOVE-CORRESPONDING ls_zshr0139 TO cs_zshr0141.                        
                                                                        
  "시차실비                                                                 
  PERFORM get_calc_tdcost USING i_pernr tdcost                          
                                cs_zshr0141                             
                                ls_zshr0143  "등급/단가                     
                          CHANGING cs_zshr0141-tdcost.                  
                                                                        
ENDFUNCTION.                                                            
