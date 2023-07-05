
function psd = copy_session_quigley(psd)

for sess = [2,3]
psd(sess).region.PPC = psd(1).region.PPC;
end

end 