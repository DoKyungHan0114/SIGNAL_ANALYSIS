%% EGB342 - Assignment 1: GenerateAssignment1Data.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%$%%
%  Clearing workspace
clear all, close all, clc
%
%  This file generates the assignment data needed to complete assignment 1. 
%  Data is generated based on team student numbers.
%
%  ****** This script only needs to be executed *ONCE*. ******
%
%  Make sure that the following files are in the same directory.
%  The directory path should not have spaces nor special characters.
%  1) initialise.p
%  2) DataGen.p
%  3) channel.p
%  4) fm_demod.p 
%  5) GenerateAssignment1Data.m
%  6) A1Training.m
%  
%  Enter your student numbers into lines 21 to 23.
%  Student numbers have the format "n01234567".
%  For student numbers beginning 'n0' - omit 'n0'
%  For all others - omit 'n' and the final digit
%  If there are only two people in your group, take the sum of the student
%  numbers and insert the first 7 digitas into st3.
%
st1 = 1007488; % Insert the first 7 digitas of your student number here (7 digits)
st2 = 8797854; % Insert the first 7 digitas of your student number here (7 digits)
st3 = 9959807; % Insert the first 7 digitas of your student number here (7 digits)
%
%  Initialise the assignment variables and save them into A1Data.mat.
DataGen(st1,st2,st3); % do not modify this line.
%
%  The initialise.p function whowill save the variables automatically. 
%  A message will be displayed on the Command Window upon successful 
%  execution of the code.
%
%  The template.m file will load and work with the A1Data.mat file directly.
%  You may close this script once A1Data.mat has been saved.