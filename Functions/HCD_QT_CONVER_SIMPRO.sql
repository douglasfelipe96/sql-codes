create or replace FUNCTION HCD_QT_CONVER_SIMPRO (CD_CONVENIO_P NUMBER,
                                                           DT_REF_P DATE,
                                                           CD_MATERIAL_P NUMBER)
RETURN NUMBER 

/*<DS_SCRIPT>
 DESCRIÇÃO...: Function que retorna a quantidade de conversão informada no Cadastro de Materiais --> Faturamento --> SIMPRO
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.fs)
 DATA........: 31/01/2023
 APLICAÇÃO...: TASY (Cadastro de Materiais)
 ATUALIZAÇÃO...:
</DS_SCRIPT>*/


IS
    IE_REGRA_CONVENIO VARCHAR2(10);
    IE_REGRA_VIGENCIA VARCHAR2(10);

    QT_RETORNO NUMBER := 0;
BEGIN 
     -- VERIFICA SE POSSUI RETORNO DE CONVENIO OU REGRA GERAL--
    SELECT DECODE(COUNT(*),0,'N','S') 
    INTO IE_REGRA_CONVENIO
    FROM MATERIAL_SIMPRO 
    WHERE CD_MATERIAL = CD_MATERIAL_P
    AND cd_convenio = CD_CONVENIO_P
    AND (TRUNC(DT_FINAL_VIGENCIA) >= DT_REF_P OR TRUNC(DT_FINAL_VIGENCIA) IS NULL)
    AND IE_SITUACAO = 'A'
    AND CD_ESTABELECIMENTO = 2;


    -- SE POSSUIR REGRA DE CONVENIO --
    IF(IE_REGRA_CONVENIO = 'S')
        THEN
            -- VERIFICA SE POSSUI REGRA DE CONVENIO COM DATA FINAL DE VIGÊNCIA DA REGRA --
            SELECT DECODE(COUNT(*),0,'N','S') 
                INTO IE_REGRA_VIGENCIA
            FROM MATERIAL_SIMPRO 
            WHERE CD_MATERIAL = CD_MATERIAL_P
            AND cd_convenio = CD_CONVENIO_P
            AND TRUNC(DT_FINAL_VIGENCIA) >= DT_REF_P
            AND IE_SITUACAO = 'A'
            AND CD_ESTABELECIMENTO = 2;

            -- SE POSSUIR REGRA DE CONVENIO COM DATA DE VIGÊNCIA, BUSCA O REGISTRO MAIS RECENTE --
            IF(IE_REGRA_VIGENCIA = 'S')
                THEN
                    SELECT QT_CONVERSAO 
                        INTO QT_RETORNO
                    FROM MATERIAL_SIMPRO
                    WHERE NR_SEQUENCIA =
                    (SELECT MAX(nr_sequencia)
                    FROM MATERIAL_SIMPRO 
                    WHERE CD_MATERIAL = CD_MATERIAL_P
                    AND cd_convenio = CD_CONVENIO_P
                    AND TRUNC(DT_FINAL_VIGENCIA) >= DT_REF_P
                    AND IE_SITUACAO = 'A'
                    AND CD_ESTABELECIMENTO = 2);

          --      DBMS_OUTPUT.PUT_LINE('Possui Regra Convênio e data final de vigência ' || QT_RETORNO);

            ELSE
            -- SE POSSUIR REGRA DE CONVENIO SEM DATA DE VIGÊNCIA, BUSCA O REGISTRO MAIS RECENTE --
                SELECT QT_CONVERSAO 
                    INTO QT_RETORNO
                FROM MATERIAL_SIMPRO
                WHERE NR_SEQUENCIA =
                (SELECT MAX(nr_sequencia)
                    FROM MATERIAL_SIMPRO 
                    WHERE CD_MATERIAL = CD_MATERIAL_P
                    AND cd_convenio = CD_CONVENIO_P
                    AND TRUNC(DT_FINAL_VIGENCIA) IS NULL
                    AND IE_SITUACAO = 'A'
                    AND CD_ESTABELECIMENTO = 2);

            --    DBMS_OUTPUT.PUT_LINE('Possui Regra Convênio e sem data final de vigência ' || QT_RETORNO);
            END IF;

    -- SE NÃO POSSUIR REGRA DE CONVENIO --
    ELSIF (IE_REGRA_CONVENIO = 'N')
        THEN
        -- VERIFICA SE POSSUI REGISTROS COM DATA DE VIGENCIA --
            SELECT DECODE(COUNT(*),0,'N','S') 
                INTO IE_REGRA_VIGENCIA
            FROM MATERIAL_SIMPRO 
            WHERE CD_MATERIAL = CD_MATERIAL_P
            AND cd_convenio IS NULL
            AND (TRUNC(DT_FINAL_VIGENCIA) >= DT_REF_P)
            AND IE_SITUACAO = 'A'
            AND CD_ESTABELECIMENTO = 2;

            -- CASO TENHA RETORNA REGISTROS DA REGRA GERAL COM DATA DE VIGENCIA --
            IF (IE_REGRA_VIGENCIA = 'S')
                THEN
                    SELECT QT_CONVERSAO 
                        INTO QT_RETORNO
                    FROM MATERIAL_SIMPRO
                    WHERE NR_SEQUENCIA =
                    (SELECT MAX(nr_sequencia)
                    FROM MATERIAL_SIMPRO 
                    WHERE CD_MATERIAL = CD_MATERIAL_P
                    AND cd_convenio IS NULL
                    AND (TRUNC(DT_FINAL_VIGENCIA) >= DT_REF_P)
                    AND IE_SITUACAO = 'A'
                    AND CD_ESTABELECIMENTO = 2);

             --   DBMS_OUTPUT.PUT_LINE('Não Possui Regra Convênio e possui regra de fim de vigência ' || QT_RETORNO);

            -- CASO CONTRÁRIO RETORNA REGISTROS DA REGRA GERAL SEM A DATA DE VIGENCIA --
            ELSIF(IE_REGRA_VIGENCIA = 'N')
                THEN
                    SELECT DECODE(COUNT(*),0,'N','S') 
                    INTO IE_REGRA_VIGENCIA
                    FROM MATERIAL_SIMPRO 
                    WHERE CD_MATERIAL = CD_MATERIAL_P
                    AND cd_convenio IS NULL
                    AND TRUNC(DT_FINAL_VIGENCIA) IS NULL
                    AND IE_SITUACAO = 'A'
                    AND CD_ESTABELECIMENTO = 2;

                    IF (IE_REGRA_VIGENCIA = 'S')
                        THEN
                            SELECT QT_CONVERSAO 
                                INTO QT_RETORNO
                            FROM MATERIAL_SIMPRO
                            WHERE NR_SEQUENCIA =
                            (SELECT MAX(nr_sequencia) 
                            FROM MATERIAL_SIMPRO 
                            WHERE CD_MATERIAL = CD_MATERIAL_P
                            AND cd_convenio IS NULL
                            AND TRUNC(DT_FINAL_VIGENCIA) IS NULL
                            AND IE_SITUACAO = 'A'
                            AND CD_ESTABELECIMENTO = 2);

                  --       DBMS_OUTPUT.PUT_LINE('Não Possui Regra Convênio e não Possui regra de fim de vigência ' || QT_RETORNO);
                    END IF;

            END IF;

    END IF;

    RETURN QT_RETORNO;

END HCD_QT_CONVER_SIMPRO;