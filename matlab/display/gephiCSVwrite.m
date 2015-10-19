function gephiCSVwrite(AffMat,label)

switch nargin
    case 1 %without label
        num_node = size(AffMat,1);
        % open the file with write permission
        fidnode = fopen('table_nodes.csv', 'w');
        fprintf(fidnode,'%s;%s;\n','Id','Label');
        fidedge = fopen('tabel_edge.csv','w');
        fprintf(fidedge,'%s;%s;%s;%s;\n','Source','Target','Type','Weight');
        
        for i = 1:num_node-1
            fprintf(fidnode,'%d;%d;\n',i,i);
            for j = i+1:num_node
                fprintf(fidedge,'%d;%d;%s;%1.2f;\n',i,j,'Undirected',AffMat(i,j));
            end
        end
        fprintf(fidnode,'%d;%d;\n',i+1,i+1);
    case 2 % with label
        num_node = size(AffMat,1);
        % open the file with write permission
        fidnode = fopen('table_nodes.csv', 'w');
        fprintf(fidnode,'%s;%s;%s;\n','Id','Label','Modularity Class');
        fidedge = fopen('table_edge.csv','w');
        fprintf(fidedge,'%s;%s;%s;%s;\n','Source','Target','Type','Weight');
        
        for i = 1:num_node-1
            fprintf(fidnode,'%d;%d;%d;\n',i,label(i),label(i));
            for j = i+1:num_node
                if AffMat(i,j)==0, continue; end
                fprintf(fidedge,'%d;%d;%s;%1.2f;\n',i,j,'Undirected',AffMat(i,j));
            end
        end
        fprintf(fidnode,'%d;%d;%d;\n',i+1,label(i),label(i+1));
end

fclose('all');
