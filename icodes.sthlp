{smcl}
{* *! version 1.1  Published July 20, 2023}{...}
{p2colset 2 12 14 28}{...}
{right: Version 1.1 }
{p2col:{bf:icodes} {hline 2}}Create numeric SIC and Fama-French industry codes{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmdab:icodes} {it:sic}
[{cmd:,}
{it:options}]

where {it:sic} is a string or numeric variable containing 4 digit SIC codes

{synoptset 16 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt suffix(text)}}append {it:text} to variable names created by {opt icodes}{p_end}
{synopt:{opt short}}use short value labels for Fama-French codes{p_end}
{synopt:{opt nolabel}}use no value labels for Fama-French codes{p_end}
{synopt:{opt nomissing}}put unmapped SICs in "other" category (explained below in {bf:Remarks}){p_end}
{synoptline}


{p2colreset}{...}
{marker description}{...}
{title:Description}

{pstd}{opt icodes} creates industry classifications for empirical analysis by converting 4 digit SIC codes in widely-used databases, such as CRSP and Compustat, to:{p_end}

{p 8 12}(1) 1, 2, 3, and 4 digit numeric SIC codes, and{p_end}
{p 8 12}(2) every Fama-French industry code (5, 10, 12, 17, 30, 38, 48, and 49).{p_end}


{marker remarks}{...}
{title:Remarks}

{p 4 6 2}
  I downloaded the files {opt icodes} uses to map SIC codes to Fama-French industry codes from {browse "http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/Data_Library/changes_ind.html":Kenneth French's website} on June 16, 2023.
  {p_end}

{p 4 6 2}
  Some SIC codes were assigned multiple Fama-French 5 and 10 industry codes in the mapping files. Methods used to address this issue are explained on my website, {browse "www.zach.prof":zach.prof}. 
  {p_end}

{p 4 6 2}
  The "other" category for Fama-French 5, 10, 12, and 38 codes are not mapped to specific SICs. Therefore, for these Fama-French codes, {opt icodes} puts unmapped SICs in the "other" category.
  {p_end}

{p 4 6 2}
  In contrast, the "other" category for Fama-French 17, 30, 48, and 49 codes {it:are} mapped to specific SICs. Therefore, {opt icodes} sets these Fama-French codes to missing by default for unmapped SICs.
  {p_end}

{p 4 6 2}
  Specifying the {opt nomissing} option puts SICs that would otherwise result in missing values in the "other" category.
  {p_end}


{marker examples}{...}
{title:Examples}

{pstd}
Examples provided at {browse "www.zach.prof":zach.prof}
{p_end}


{marker contact}{...}
{title:Author}

{pstd}
Zachary King{break}
Email: {browse "mailto:me@zach.prof":me@zach.prof}{break}
Website: {browse "www.zach.prof":zach.prof}{break}
SSRN: {browse "https://papers.ssrn.com/sol3/cf_dev/AbsByAuth.cfm?per_id=2623799":https://papers.ssrn.com}
{p_end}


{title:Acknowledgements}

{pstd}
I thank the following individuals for helpful feedback and suggestions on {opt icodes}, this help file, and the associated documentation on {browse "www.zach.prof":zach.prof}:{p_end}

{pstd}
Mayer Liang {break}
Jessica Nylen
{p_end}
