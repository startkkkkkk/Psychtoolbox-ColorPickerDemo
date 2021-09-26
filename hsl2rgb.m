
function [R,G,B] = hsl2rgb(H,S,L)
%HSL2RGB 
    [m,n]=size(H);
    % 单值RGB 
    if m==1&&n==1
        if S~=0
            if L<0.5
                q=L*(1+S);
            else
                q=L+S-(L*S);
            end
            p=2*L-q;
            hk=H/360;
            R_temp=hk+1/3;
            G_temp=hk;
            B_temp=hk-1/3;
            R=hsl2rgb_subfun(R_temp,p,q);
            G=hsl2rgb_subfun(G_temp,p,q);
            B=hsl2rgb_subfun(B_temp,p,q);
        else
            R=L;G=L;B=L;
        end
    % 图片RGB
    else
        R=zeros(m,n);G=zeros(m,n);B=zeros(m,n);
        for i=1:m
            for j=1:n
                s=S(i,j);   
                l=L(i,j);         
                if s~=0
                    h=H(i,j);      
                    if l<0.5
                        q=l*(1+s);
                    else
                        q=l+s-(l*s);
                    end
                    p=2*l-q;
                    hk=h/360;
                    R_temp=hk+1/3;
                    G_temp=hk;
                    B_temp=hk-1/3;
                    
                    R(i,j)=hsl2rgb_subfun(R_temp,p,q);
                    G(i,j)=hsl2rgb_subfun(G_temp,p,q);
                    B(i,j)=hsl2rgb_subfun(B_temp,p,q);
                else
                    R(i,j)=l;
                    G(i,j)=l;
                    B(i,j)=l;
                end
            end
        end
    end
end
 
function re = hsl2rgb_subfun(t,p,q)
        if t<0
            t=t+1.0;
        elseif t>1
            t=t-1.0;
        end
        if t<1/6
            re=p+((q-p)*6*t);
        elseif 1/6<=t && t<0.5
            re=q;
        elseif 0.5<=t && t<2/3
            re=p+((q-p)*6*(2/3-t));
        else
            re=p;
        end
    end 