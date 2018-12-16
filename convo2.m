clear;
close;


snr=0:0.5:10;
N=1000;


for j=1:length(snr)

k=randi([0,1],1,N);

m1=zeros(1,length(k)+4);
for i=1:length(k);
    m1(i+2)=k(i);
end
g1=zeros(1,length(k)+2);
g2=zeros(1,length(k)+2);
for i=1:length(k)+2;
    g1(i)=xor(xor(m1(i),m1(i+1)),m1(i+2));
end

for i=1:length(k)+2;
    g2(i)=xor(m1(i),m1(i+2));
end

g=zeros(1,2*length(k)+4);

for i=1:(length(k)+2);
    g(2*i)=g2(i);
    g(2*i-1)=g1(i);
end


a=size(g); %�������еĳ���
s=a(2)/2; %������m���г���Ϊx��һ��


x=awgn(g,snr(j),'measured');

for i=1:2*s;
    if x(i)>=0.5
        x(i)=1;
    else
        x(i)=0;
    end
end

m=zeros(1,s); %���ս�����
ma=zeros(1,s+1); %���Fa·����
mb=zeros(1,s+1); %���Fb·����
mc=zeros(1,s+1); %���Fc·����
md=zeros(1,s+1); %���Fd·����
tempma=zeros(1,s+1);%ÿ��ʱ�̵���С·��ֵ
tempmb=zeros(1,s+1);%ÿ��ʱ�̵���С·��ֵ
tempmc=zeros(1,s+1);%ÿ��ʱ�̵���С·��ֵ
tempmd=zeros(1,s+1);%ÿ��ʱ�̵���С·��ֵ
Fa=0;
Fb=0;
Fc=0;
Fd=0;
for i=1:s
    tempma=ma;
    tempmb=mb;
    tempmc=mc;
    tempmd=md;
    if i==1
        d0=dis(x(1),x(2),0,0);
        d3=dis(x(1),x(2),1,1);
        Fa=Fa+d0;
        Fb=Fb+d3;
        ma(i)=0;
        mb(i)=0;
        mc(i)=0;
        md(i)=0;
        continue;
    elseif i==2
        d0=dis(x(3),x(4),0,0);%d0=1
        d1=dis(x(3),x(4),0,1);%d1=2
        d2=dis(x(3),x(4),1,0);%d2=0
        d3=dis(x(3),x(4),1,1);%d3=1
        Fc=Fb+d2;  %0-->10-->01 0+1+0=1(��λ) 0+0=0����λ�� ���������Ϊ��10
        Fd=Fb+d1; %1-->10-->11 1+1+0=0 1+0=1 ���������Ϊ��01
        Fb=Fa+d3;
        Fa=Fa+d0; 
        ma(i)=0;
        mb(i)=0;
        mc(i)=2;
        md(i)=2;
        continue;
    elseif i==s-1
        d0=dis(x(2*i-1),x(2*i),0,0);
        d1=dis(x(2*i-1),x(2*i),0,1);
        d2=dis(x(2*i-1),x(2*i),1,0);
        d3=dis(x(2*i-1),x(2*i),1,1);
        if Fa+d0<Fc+d3
            Fa=Fa+d0;
            ma=tempma;
            ma(i)=0;
        else
            Fa=Fc+d3;
            ma=tempmc;
            ma(i)=1;
        end
        if Fb+d3<Fd+d1
            Fc=Fb+d3;
            mc=tempmb;
            mc(i)=2;
        else
            Fc=Fd+d1;
            mc=tempmd;
            mc(i)=3;
        end
        continue;
    elseif i==s
        d0=dis(x(2*i-1),x(2*i),0,0);
        d3=dis(x(2*i-1),x(2*i),1,1);
        if Fc+d3<Fa+d0
            Fa=Fc+d3;
            ma=tempmc;
            ma(i)=1;
        else
            Fa=Fa+d0;
            ma=tempma;
            ma(i)=0;
        end
        continue;
        
        
    elseif i>2
        d0=dis(x(2*i-1),x(2*i),0,0);
        d1=dis(x(2*i-1),x(2*i),0,1);
        d2=dis(x(2*i-1),x(2*i),1,0);
        d3=dis(x(2*i-1),x(2*i),1,1);
       
        if Fa+d0<Fc+d3 %����00״̬������·���Ƚϴ�С
            Fa=Fa+d0; %0-->00-->00 ���������00 0+0+0=0 0+0=0
            ma=tempma;
            ma(i)=0;
        else 
            Fa=Fc+d3;%0-->01-->00 ���������11  0+0+1=1 0+1=1
            ma=tempmc;
            ma(i)=1;
        end
        if Fa+d3<Fc+d0 %����10״̬������·���Ƚϴ�С
            Fb=Fa+d3;%1-->00-->10 ���������11  1+0+0=1 1+0=1
            mb=tempma;
            mb(i)=0;
        else
            Fb=Fc+d0;%1-->01-->10 ���������00  1+0+1=0 1+1=0
            mb=tempmc;
            mb(i)=1;
        end
        if Fb+d2<Fd+d1
            Fc=Fb+d2;%0-->10-->01  ���������10  0+1+0=1 0+0=0  
            mc=tempmb;
            mc(i)=2;
        else
            Fc=Fd+d1;%0-->11-->01  ���������01  0+1+1=0 0+1=1
            mc=tempmd;
            mc(i)=3;
        end
        if Fb+d1<Fd+d2; %����11״̬������·���Ƚϴ�С
            Fd=Fb+d1;%1-->10-->11 ���������01  1+1+0=0 1+0=1
            md=tempmb;
            md(i)=2;
        else
            Fd=Fd+d2;%1-->11-->11 ���������10  1+1+1=1 1+1=0
            md=tempmd;
            md(i)=3;
        end
    end
end
     ma(s+1)=0;
     for t=1:s
         if ma(t)<ma(t+1)
             m(t)=1;
         elseif (ma(t)==ma(t+1))&&(ma(t)==3)
             m(t)=1;
         else
             m(t)=0;
         end
     end
 
          
 sum=0;
 for i=1:length(k)
     if m(i)~=k(i)
         sum=sum+1;
     end
 end
 
 p_error(j)=sum/length(k);        
end   
   
 semilogy(snr,p_error); 

        
            
        

        



