import matplotlib.pyplot as plt

import seaborn as sns
import numpy as np
import pandas as pd

results=pd.read_csv('/home/wtian/tmp/hjx/GO_KEGG/example.input',sep="\t")

categories = results['ONTOLOGY'].unique()

# Setting up subplots
# fig, axes = plt.subplots(nrows=1, ncols=len(categories), figsize=(18, 8), sharey=True)

# Plotting for each category
# for ax, category in zip(axes, categories):
#     # pass

for category in categories:
# category = "BP"
    subset = results[results['ONTOLOGY'] == category]
    subset = subset.nsmallest(5, 'pvalue')

    # Normalize the pvalues for color mapping
    log_pvalues = -np.log10(subset['pvalue'])
    norms = plt.Normalize(log_pvalues.min(), log_pvalues.max())
    sm = plt.cm.ScalarMappable(cmap="coolwarm", norm=norms)
    sm.set_array([])

    fig, ax = plt.subplots(figsize=(10, 6))
    colors_mf = plt.cm.coolwarm(norms(log_pvalues))
    sns.barplot(
        x='Count', 
        y='ID', 
        data=subset, 
        palette=colors_mf,
        ax=ax
    )
    # Adding title and labels
    ax.set_title(f'Top 5 Enrichment Results for {category}')
    ax.set_xlabel('Count')
    ax.set_ylabel('Enrichment Result ID')

    # Adding a color bar common to all subplots
    cbar = fig.colorbar(sm, ax=ax, orientation='vertical')
    cbar.set_label('-log10(pvalue)')

    # # Show plot
    # plt.show()

    output_file = '/home/wtian/tmp/hjx/GO_KEGG/example.'+category+'.GO.PYoutput.png'
    # 保存绘图
    plt.savefig(output_file, dpi=300)