Feature: Command line interface

Scenario: How to cite
    When I successfully run `ecf_classify cite`
    Then the stdout should contain:
      """
      Casas-Pastor D, Müller RR, Jaenicke S, Brinkrolf K, Becker A, Buttner MJ, Gross CA, Mascher T, Goesmann A, Fritz G. Expansion and re-classification of the extracytoplasmic function (ECF) σ factor family. Nucleic Acids Res. 2021 Jan 4:gkaa1229. doi: 10.1093/nar/gkaa1229. Epub ahead of print. PMID: 33398323.
      """
