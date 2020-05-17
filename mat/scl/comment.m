
% LLR-based SCL deocoder, a single function, no other sub-functions.
% Frequently calling sub-functions will derease the efficiency of MATLAB 
% 
% If Lazy Copy is used, 
% there is no data-copy in the decoding process. 
% We only need to record where the data come from. 
% Here, data refer to LLRs and partial sums.
% Lazy Copy is a relatively sophisticated operation for new learners of polar codes. 
% If you do not understand such operation, 
% you can directly copy data.
% If you can understand lazy copy and you just start learning polar codes
% for just fews days, you are very clever!