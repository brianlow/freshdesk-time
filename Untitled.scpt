FasdUAS 1.101.10   ��   ��    k             l     ��  ��    D > Copyright (c) 2021 Timing Software GmbH. All rights reserved.     � 	 	 |   C o p y r i g h t   ( c )   2 0 2 1   T i m i n g   S o f t w a r e   G m b H .   A l l   r i g h t s   r e s e r v e d .   
  
 l     ��  ��    � � This script is licensed only to extend the functionality of Timing. Redistribution and any other uses are not allowed without prior permission from us.     �  0   T h i s   s c r i p t   i s   l i c e n s e d   o n l y   t o   e x t e n d   t h e   f u n c t i o n a l i t y   o f   T i m i n g .   R e d i s t r i b u t i o n   a n d   a n y   o t h e r   u s e s   a r e   n o t   a l l o w e d   w i t h o u t   p r i o r   p e r m i s s i o n   f r o m   u s .      l     ����  O         Z      ����  H       1    ��
�� 
ScrA  R    �� ��
�� .ascrerr ****      � ****  m       �   � S c r i p t i n g   s u p p o r t   r e q u i r e s   a   T i m i n g   E x p e r t   l i c e n s e .   P l e a s e   c o n t a c t   s u p p o r t   v i a   h t t p s : / / t i m i n g a p p . c o m / c o n t a c t   t o   u p g r a d e .��  ��  ��    m       �                                                                                      @ alis    �  Macintosh HD                   BD ����TimingHelper.app                                               ����            ����  
 cu             
LoginItems  G/:Applications:Timing.app:Contents:Library:LoginItems:TimingHelper.app/   "  T i m i n g H e l p e r . a p p    M a c i n t o s h   H D  DApplications/Timing.app/Contents/Library/LoginItems/TimingHelper.app  / ��  ��  ��        l    ����  r        m         ldt    Kl�{�  o      ���� 0 	from_date  ��  ��     ! " ! l     ��������  ��  ��   "  # $ # l     %���� % r      & ' & I   ������
�� .misccurdldt    ��� null��  ��   ' o      ���� 0 datevar  ��  ��   $  ( ) ( l     �� * +��   *  set hours of datevar to 7    + � , , 2 s e t   h o u r s   o f   d a t e v a r   t o   7 )  - . - l  ! & /���� / r   ! & 0 1 0 m   ! "����   1 n       2 3 2 1   # %��
�� 
min  3 o   " #���� 0 datevar  ��  ��   .  4 5 4 l  ' , 6���� 6 r   ' , 7 8 7 m   ' (����   8 n       9 : 9 m   ) +��
�� 
scnd : o   ( )���� 0 datevar  ��  ��   5  ; < ; l     ��������  ��  ��   <  = > = l  - � ?���� ? O   - � @ A @ k   1 � B B  C D C r   1 8 E F E I  1 6�� G��
�� .corecrel****      � null G m   1 2��
�� 
ReSe��   F o      ����  0 reportsettings reportSettings D  H I H r   9 @ J K J I  9 >�� L��
�� .corecrel****      � null L m   9 :��
�� 
ExSe��   K o      ����  0 exportsettings exportSettings I  M N M l  A A��������  ��  ��   N  O P O e   A E Q Q n   A E R S R 1   B D��
�� 
pALL S o   A B����  0 reportsettings reportSettings P  T U T l  F F��������  ��  ��   U  V W V O   F � X Y X k   J � Z Z  [ \ [ r   J Q ] ^ ] m   J K��
�� ReGrRGMo ^ 1   K P��
�� 
GrM1 \  _ ` _ r   R [ a b a m   R U��
�� ReGrRGPr b 1   U Z��
�� 
GrM2 `  c d c l  \ \��������  ��  ��   d  e f e r   \ c g h g m   \ ]��
�� boovtrue h 1   ] b��
�� 
TaIn f  i j i r   d k k l k m   d e��
�� boovtrue l 1   e j��
�� 
TtIn j  m n m r   l s o p o m   l m��
�� boovtrue p 1   m r��
�� 
AGTt n  q r q r   t { s t s m   t u��
�� boovtrue t 1   u z��
�� 
TtsI r  u v u r   | � w x w m   | }��
�� boovtrue x 1   } ���
�� 
TnIn v  y z y l  � ���������  ��  ��   z  { | { r   � � } ~ } m   � ���
�� boovtrue ~ 1   � ���
�� 
AUIn |   �  r   � � � � � m   � ���
�� boovtrue � 1   � ���
�� 
ApIn �  � � � r   � � � � � m   � ���
�� boovtrue � 1   � ���
�� 
TsIn �  � � � l  � ���������  ��  ��   �  ��� � r   � � � � � m   � ���
�� boovtrue � 1   � ���
�� 
AGAp��   Y o   F G����  0 reportsettings reportSettings W  � � � l  � ���������  ��  ��   �  � � � O   � � � � � k   � � � �  � � � r   � � � � � m   � ���
�� ExTyETHt � 1   � ���
�� 
ESFF �  � � � l  � ���������  ��  ��   �  � � � r   � � � � � m   � ���
�� ExDFDFSe � 1   � ���
�� 
ESDF �  � � � l  � ���������  ��  ��   �  ��� � r   � � � � � m   � ���
�� boovtrue � 1   � ���
�� 
ESSE��   � o   � �����  0 exportsettings exportSettings �  � � � l  � ���������  ��  ��   �  � � � I  � ����� �
�� .Savereponull��� ��� null��   � �� � �
�� 
Rese � o   � �����  0 reportsettings reportSettings � �� � �
�� 
Exse � o   � �����  0 exportsettings exportSettings � �� � �
�� 
Stdt � o   � ����� 0 datevar   � �� � �
�� 
Endt � o   � ����� 0 datevar   � �� ���
�� 
Srur � m   � � � � � � � X / U s e r s / b r i a n s h i f t / D o w n l o a d s / t i m e / e x p o r t . h t m l��   �  � � � l  � ���������  ��  ��   �  � � � l  � ��� � ���   � _ Y these commands are required to avoid accumulating old settings (and thus leaking memory)    � � � � �   t h e s e   c o m m a n d s   a r e   r e q u i r e d   t o   a v o i d   a c c u m u l a t i n g   o l d   s e t t i n g s   ( a n d   t h u s   l e a k i n g   m e m o r y ) �  � � � I  � ��� ���
�� .coredelonull���     obj  � o   � �����  0 reportsettings reportSettings��   �  ��� � I  � ��� ��
�� .coredelonull���     obj  � o   � ��~�~  0 exportsettings exportSettings�  ��   A m   - . � ��                                                                                      @ alis    �  Macintosh HD                   BD ����TimingHelper.app                                               ����            ����  
 cu             
LoginItems  G/:Applications:Timing.app:Contents:Library:LoginItems:TimingHelper.app/   "  T i m i n g H e l p e r . a p p    M a c i n t o s h   H D  DApplications/Timing.app/Contents/Library/LoginItems/TimingHelper.app  / ��  ��  ��   >  ��} � l     �|�{�z�|  �{  �z  �}       �y � ��y   � �x
�x .aevtoappnull  �   � **** � �w ��v�u � ��t
�w .aevtoappnull  �   � **** � k     � � �   � �   � �  # � �  - � �  4 � �  =�s�s  �v  �u   �   � * �r   �q�p�o�n�m�l�k�j�i�h�g�f�e�d�c�b�a�`�_�^�]�\�[�Z�Y�X�W�V�U�T�S�R�Q�P ��O�N�M
�r 
ScrA�q 0 	from_date  
�p .misccurdldt    ��� null�o 0 datevar  
�n 
min 
�m 
scnd
�l 
ReSe
�k .corecrel****      � null�j  0 reportsettings reportSettings
�i 
ExSe�h  0 exportsettings exportSettings
�g 
pALL
�f ReGrRGMo
�e 
GrM1
�d ReGrRGPr
�c 
GrM2
�b 
TaIn
�a 
TtIn
�` 
AGTt
�_ 
TtsI
�^ 
TnIn
�] 
AUIn
�\ 
ApIn
�[ 
TsIn
�Z 
AGAp
�Y ExTyETHt
�X 
ESFF
�W ExDFDFSe
�V 
ESDF
�U 
ESSE
�T 
Rese
�S 
Exse
�R 
Stdt
�Q 
Endt
�P 
Srur�O 

�N .Savereponull��� ��� null
�M .coredelonull���     obj �t �� *�, 	)j�Y hUO�E�O*j E�Oj��,FOj��,FO� ��j 
E�O�j 
E�O��,EO� [�*a ,FOa *a ,FOe*a ,FOe*a ,FOe*a ,FOe*a ,FOe*a ,FOe*a ,FOe*a ,FOe*a ,FOe*a ,FUO� a *a ,FOa *a ,FOe*a  ,FUO*a !�a "�a #�a $�a %a &a ' (O�j )O�j )Uascr  ��ޭ