
function psd_all = create_psd_stack_all(psd)

for reg = ["PPC","PFC","MST"]
    
    psd_all.region.(reg).stationary = [];
    psd_all.region.(reg).stat_sem = [];
    psd_all.region.(reg).mobile = [];
    psd_all.region.(reg).mob_sem = [];
    
end 
    
end 