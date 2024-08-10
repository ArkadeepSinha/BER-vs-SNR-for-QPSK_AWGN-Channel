close all;
clear all;

blockLength = 1000;
nBlocks=10000;
EbdB = 1.0:1.0:10.0;
Eb = 10.^(EbdB/10);
No = 1;
SNR = 2*Eb/No;
SNRdB = 10*log10(SNR);
SER = zeros(1,length(EbdB));
BER = zeros(1,length(EbdB));

for blk=1:nBlocks
    BitsI=randi([0,1],1,blockLength);
    BitsQ=randi([0,1],1,blockLength);
    Sym=(2*BitsI-1)+1j*(2*BitsQ-1);
    noise=sqrt(No/2)*(randn(1,blockLength)+1j*randn(1,blockLength));
    for K=1:length(EbdB)
        TxSym=sqrt(Eb(K))*Sym;
        RxSym=TxSym+noise;
        DecBitsI=(real(RxSym)>0);
        DecBitsQ=(imag(RxSym)>0);
        SER(K)= SER(K) + sum(or(DecBitsI ~= BitsI, DecBitsQ ~=BitsQ));
        BER(K)= BER(K) + sum(DecBitsI ~=BitsI) + sum(DecBitsQ ~= BitsQ);
    end
end

SER=SER/blockLength/nBlocks;
BER=BER/blockLength/nBlocks/2;

semilogy(SNRdB,SER,'b  s','linewidth',3.0,'MarkerFaceColor','b','MarkerSize',9.0);
hold on;
semilogy(SNRdB,2*GaussianQ(sqrt(SNR)),'r -  ','linewidth',3.0);
semilogy(SNRdB,BER,'g  s','linewidth',3.0,'MarkerFaceColor','g','MarkerSize',9.0);
semilogy(SNRdB,GaussianQ(sqrt(SNR)),'k -  ','linewidth',3.0);
axis tight;
grid on;
legend('SER','SER Theory','BER','BER Theory')
xlabel('SNR (dB)');
ylabel('SER/ BER');
title('SER/ BER vs SNR(dB) for Digital Comm with QPSK');


