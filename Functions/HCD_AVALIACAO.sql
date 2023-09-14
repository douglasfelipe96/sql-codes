create or replace function hcd_avaliacao (nr_seq_avaliacao_p number,
                                          nr_seq_superior_p number)
                        return varchar2 is 
                    
ds_resultado_w varchar2(255);


begin

select b.ds_item
into ds_resultado_w
from med_avaliacao_result a,
    med_item_avaliar b
where b.nr_sequencia = a.nr_seq_item
and a.nr_seq_avaliacao = nr_seq_avaliacao_p
--and a.nr_seq_item = nr_seq_item_p
and b.nr_seq_superior = nr_seq_superior_p
and qt_resultado = 1;

return ds_resultado_w;

end hcd_avaliacao;