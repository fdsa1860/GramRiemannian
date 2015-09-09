% Update Caglayan Dicle on January 15 2014.
%       The average error computation is update to mean-squared-error and
%       convergence check updated accordingly. The new metric considers the
%       dimension of the data. It is more correct update and inline with
%       hstln minimization.
function [u_hat,eta,x,R] = fast_incremental_hstln_mo(u,eta_max,varargin)
% function [u_hat,eta,x,R] = incremental_hstln_mo(u,eta_max,R_max,Omega)

[D_u,N_u] = size(u);

nc = floor((N_u+1)*D_u/(D_u+1));  % pick as fewest columns as possible
nr = (N_u-nc+1)*D_u;

defMaxRank = min([nr nc]);
defMinRank = 1;
defOmega   = ones(1,N_u);

% Check user input parameters
p = inputParser;

addParamValue(p,'maxrank',defMaxRank,@isnumeric);
addParamValue(p,'minrank',defMinRank,@isnumeric);
addParamValue(p,'omega',defOmega,@isnumeric);
parse(p,varargin{:});


R_max = p.Results.maxrank;
R_max = min([nr nc R_max]);
R_min = p.Results.minrank;
Omega = p.Results.omega;








for R=R_min:R_max-1

%     R
    % do if for 10 iterations
    [u_hat,eta,x,av_eta] = fast_hstln_mo(u,R,'omega',Omega,...
                    'maxiter',10,'tol',1e-4); % to speed it up

    % recalculate average eta
%     av_eta  = norm(bsxfun(@times,eta,Omega),'fro')/sum(Omega);
    av_eta  = norm(bsxfun(@times,eta,Omega),'fro')^2/(D_u*sum(Omega));
    
%     plot([u' u_hat'])
%     drawnow;
    
    % if this is a promising rank
    if av_eta < eta_max^2*1.5
        % improve the last solution
        [u_hat,eta,x,av_eta] = fast_hstln_mo(u,R,'x0',x,'omega',Omega,...
                    'maxiter',30,'tol',1e-4); 
        
        av_eta  = norm(bsxfun(@times,eta,Omega),'fro')^2/(D_u*sum(Omega));
        
        if av_eta < eta_max^2
            break;
        end
    end


    
    
end
