

function [ Thr ] = RS_Threshold( RS, alpha )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
  RSs=sort(RS);
  RS_l=length(RSs);
  Thr = RSs(floor(RS_l*(1-alpha))); 
end