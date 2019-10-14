#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 11 17:39:26 2018

@author: dcasas
"""
from Bio import SeqIO
import os
import sys
import argparse

parser = argparse.ArgumentParser(description="Extract ECFs")
parser.add_argument('--general',help="general ecf model domtblout file")
parser.add_argument('--sigma3',help="sigma3 pfam model domtblout file")
parser.add_argument('--pfam',help="sigma2 and sigma4 pfam models domtblout file")
parser.add_argument("--infile", help="sequences to extract")
parser.add_argument("--conserved", help="outfile: conversed regions of ecfs")

args = parser.parse_args()

file_seqs = args.infile

proteins = []
seqs = {}
with open(file_seqs, 'r') as reader:
    for record in SeqIO.parse(reader, 'fasta'):
        proteins.append(record.id)
        seqs[record.id] = str(record.seq)

#presence of sigma2 and sigma4
hmmscan_cons = {protein:[False,False] for protein in proteins}
with open(args.pfam, 'r') as reader:
    for row in reader:
        if not row.startswith('#'):
            row = row.strip().split(' ')
            row=list(filter(None, row))
            if row[0] == 'Sigma70_r2':
                if not hmmscan_cons[row[3]][0]:
                  hmmscan_cons[row[3]][0] = (row[17],row[18])
            elif (row[0] == 'Sigma70_r4' or row[0] == 'Sigma70_r4_2'):
                if not hmmscan_cons[row[3]][1]:
                  hmmscan_cons[row[3]][1] = (row[17],row[18])

#presence of sigma3
hmmscan_s3 = {protein:False for protein in proteins}
with open(args.sigma3, 'r') as reader:
    for row in reader:
        if not row.startswith('#'):
            row = row.strip().split(' ')
            row=list(filter(None, row))
            if row[0] == 'Sigma70_r3':
                hmmscan_s3[row[3]] = True
   
#Score of the general HMM             
positives = {protein:0 for protein in proteins}
with open(args.general, 'r') as reader:
    for row in reader:
        if not row.startswith('#'):
            row = row.strip().split(' ')
            row=list(filter(None, row))
            positives[row[3]] = float(row[7])

# Extract postions of sigma2 and sigma4
hmmscan = {protein:{'Sigma2': [0,0,10], 'Sigma4': [0,0,10]} for protein in proteins}
with open(args.pfam, 'r') as reader:
    for row in reader:
        if not row.startswith('#'):
            row = row.strip().split(' ')
            row=list(filter(None, row))
            if row[0] == 'Sigma70_r2' and float(row[11]) < hmmscan[row[3]]['Sigma2'][2]:
                hmmscan[row[3]]['Sigma2'] = [int(row[19]), int(row[20]), float(row[11])]
            elif (row[0] == 'Sigma70_r4' or row[0] == 'Sigma70_r4_2')\
                and float(row[11]) < hmmscan[row[3]]['Sigma4'][2]:
                hmmscan[row[3]]['Sigma4'] = [int(row[19]), int(row[20]), float(row[11])]

ecfs = []
writer = sys.stdout
writer.write('\t'.join(['ID', 'sigma3?','sigma2?', 'sigma4?',
                        'Distance sigma2-sigma4 (aa)','sigma2_start','sigma2_end','sigma4_start', 'sigma4_end', 'Score general ECF HMM','Type'])+'\n')
for p in proteins:
    writer.write(p+'\t')
    #Check domains
    for n in [hmmscan_s3[p], hmmscan_cons[p][0], hmmscan_cons[p][1]]:
        if n:
            writer.write('x\t')
        else:
            writer.write(' \t')
    #Distance between sigma2-sigma4
    if hmmscan_cons[p][0] and hmmscan_cons[p][1]:
        writer.write(str(hmmscan[p]['Sigma4'][0]-(hmmscan[p]['Sigma2'][1]+1))+'\t')
    else:
        writer.write('-\t')

    #Positions of sigma2 and sigma4 (if available)
    if hmmscan_cons[p][0]:
        writer.write("{}\t{}\t".format(*hmmscan[p]['Sigma2'][0:2]))
    else:
        writer.write('-\t-\t')
    if hmmscan_cons[p][1]:
        writer.write("{}\t{}\t".format(*hmmscan[p]['Sigma4'][0:2]))
    else:
        writer.write('-\t-\t')

    #Check general model score
    writer.write(str(positives[p])+'\t')
    #make decision
    if hmmscan_s3[p]:
        writer.write('Non-ECF\n')
    elif hmmscan_cons[p][0] and hmmscan_cons[p][1]:
        if (hmmscan[p]['Sigma4'][0]-(hmmscan[p]['Sigma2'][1]+1)) >=50:
            writer.write('Non-ECF\n')
        elif positives[p] >= 60.8:
            writer.write('ECF\n')
            ecfs.append(p)
        else:
            writer.write('Non-ECF\n')
    elif hmmscan_cons[p][0] or hmmscan_cons[p][1]:
        writer.write('ECF-like\n')
    else:
        writer.write('Non-ECF\n')



#Extract only the conserved domains
with open(args.conserved, 'w') as writer:
    for p in ecfs:
        start2 = hmmscan[p]['Sigma2'][0]-1
        end2 = hmmscan[p]['Sigma2'][1]
        start4 = hmmscan[p]['Sigma4'][0]-1
        end4=hmmscan[p]['Sigma4'][1]
        writer.write('>{}\n{}{}\n'.format(p, seqs[p][start2:end2], seqs[p][start4:end4]))

            

        
