#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Dec  5 16:13:59 2018

@author: dcasas

Calculate correspondence to new groups 
run first:
hmmscan --domtblout hmmscan_res.txt ../HMMs_all/all_models.hmm to_classify.fa > /dev/null"""

import os
import numpy as np
import errno
import sys
import argparse

parser = argparse.ArgumentParser(description="Classify ECFs")
parser.add_argument('--hmm-result',help="groups/subgroups ecf model domtblout file")
parser.add_argument('--th',help="probability threshold for groups/subgroups")
parser.add_argument('--stats-file',help="path to file with the trusted and noise thresholds, and fitting values for the logistic curve")
parser.add_argument("--probabilities", help="output file: probabilities of proteins' classification")
parser.add_argument("--ungrouped", help="Name for the case no group was found; default: UG", default= "UG")

args = parser.parse_args()

np.seterr(all='ignore')

def sigmoid(x, x0, k, m, sd):
     y = 1 / (1 + np.exp(-k*(((x-m)/sd)-x0)))
     return y

file_hmmscan = args.hmm_result
file_out = sys.stdout
UG = args.ungrouped
#%%
'''Excecute only the first time to obtain the correspondence old-new'''
'''Read statistics table'''
trusted ={}
noise = {}
logistic = {}
with open(args.stats_file, 'r') as reader:
    for i, row in enumerate(reader):
        if i > 0:
            row = row.strip().split('\t')
            trusted[row[0]] = float(row[1])
            noise[row[0]] = float(row[2])
            if row[-1] != 'Optimal not found' and float(row[-3]) != 0:
                logistic[row[0]] = [float(row[-2]), float(row[-1]), float(row[-4]),float(row[-3])]
clusters_list = [a for a in trusted]

'''Read all the proteins in groups
#Load bit scores'''   
bit_scores = {}
with open(file_hmmscan, 'r') as reader:
    for row in reader:
        if not row.startswith('#'):
            row = row.strip().split(' ')
            row = list(filter(None, row))
#            if row[0] == 'ECF236.fa-iter2':
#                row[0] = 'ECF120.fa-iter2'            
            if row[3] in bit_scores:
                index = clusters_list.index(row[0].split('.')[0])
                bit_scores[row[3]][index] = float(row[7])
            else:
                bit_scores[row[3]] = [0 for a in clusters_list]
                index = clusters_list.index(row[0].split('.')[0])
                bit_scores[row[3]][index] = float(row[7])
                
roc = float(args.th)#sys.argv[1])

'''
Classification using the TRUSTED cut-off or NOISE cut-off (the minimum) of each HMM.
Obtain the probability from the LOGISTIC curve. only if probability is > threshold would it be classified
'''
classify={p: '' for p in bit_scores}
probability = {p: [] for p in bit_scores}
for protein in bit_scores:
    results = []
    for i, score in enumerate(bit_scores[protein]):
        if score != 0: #create a variable with all the probabilites. 
            if clusters_list[i] in logistic: #if the cluster has a logistic fit
                pr = sigmoid(score, logistic[clusters_list[i]][0], 
                    logistic[clusters_list[i]][1],
                    logistic[clusters_list[i]][2], 
                    logistic[clusters_list[i]][3])
            else:
                pr = '-'
        else: #0 if score is 0
            pr = 0
        probability[protein].append(pr)
        if score >= trusted[clusters_list[i]]:
            if clusters_list[i] in logistic: #if the cluster has a logistic fit
                pr=sigmoid(score, logistic[clusters_list[i]][0], logistic[clusters_list[i]][1],
                           logistic[clusters_list[i]][2], logistic[clusters_list[i]][3])
            else:
                pr = '-'
            results.append([clusters_list[i], pr])
    if len(results) == 0:
        for i, score in enumerate(bit_scores[protein]):
            if score >= noise[clusters_list[i]]:
                if clusters_list[i] in logistic:#if the cluster has a logistic fit. If not i dont consider it
                    pr=sigmoid(score, logistic[clusters_list[i]][0], logistic[clusters_list[i]][1],
                           logistic[clusters_list[i]][2], logistic[clusters_list[i]][3])
                results.append([clusters_list[i], pr])
    prs = [a[1] for a in results]
    groups = [a[0] for a in results]
    if prs != ['-']: #if some subgroups have logistic regression
        prs = [a if a != '-' else 0 for a in prs] #substitute '-' by 0
        results_s = [[a,z] for a,z in sorted(zip(prs,groups), reverse=True)]
    else:
        results_s = [[1, groups[0]]] #if the protein only fits one group and this group couldt be adjusted to logistic curve
    if results_s == []:#if the protein does not classify against anything
        classify[protein] = UG
        continue
    if results_s[0][0]>roc:
        classify[protein] = results_s[0][1]
    if classify[protein] == '':
        classify[protein] = UG

writer = sys.stdout
writer.write('ID\tGroup\n')
for p in classify:
    writer.write('\t'.join([p, classify[p]])+'\n')

if args.probabilities:
  with open(args.probabilities, 'w') as writer:
      writer.write('\t'.join(['Protein']+clusters_list)+'\n')
      for protein in probability:
          writer.write('\t'.join([protein]+[str(a) for a in probability[protein]])+'\n')

