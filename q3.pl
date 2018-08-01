/*
 * **********************************************
 * aux predicates (see ex5-aux.pl documentation)
 * **********************************************
 */
:- use_module('ex5-aux').

/*
 * **********************************************
 * Question 3:
 * 
 * A relational database for Wikipedia management.
 * 
 * The database contains the tables: page, namespaces,
 * category and categorylinks.
 * **********************************************
 */

% Signature: page_in_category(PageName, CategoryId)/2
% Purpose: Relation between a page name and a category id,
%          so that the page is included in the category.
%          and the category is not hidden.
% Examples:
% ?- page_in_category(cnn, X).
% X = 786983;
% X = 786983
%
% ?- page_in_category(X, 564677).
% X = ocpc;
% X = nbc.
%
% ?- page_in_category(metropolitan, X).
% false.
%
page_in_category(PName, CatId) :- category(CatId,Z,false),categorylinks(X, Z), page(X,_,PName,_).

% Signature: splitter_category(CategoryId)/1
% Purpose: A category that has at least two pages.
%          Multiple right answers may be given.
%
% Examples:
% ?- splitter_category(689969).
% true.
%
% ?- splitter_category(564677).
% true.
%
% ?- splitter_category(858585).
% false.
%
splitter_category(CatId):- category(CatId,Y,_), categorylinks(Z1,Y),categorylinks(Z2,Y), Z1 \= Z2.

% Signature: namespace_list(NamespaceName, PageList)/2
% Purpose: PageList includes all the pages in namespace NamespaceName.
%          The order of list elements is irrelevant.
% Examples:
% ?- namespace_list(article, X).
% X = [558585, 689695, 858585].
%

namespace_list(Name,X) :- namespace_list_Helper(Name,[],X). 
namespace_list_Helper(Name, List,X) :- namespaces(ID,Name),page(Y,ID,_,_), not_member(Y,List), append([Y|[]],List,Z),namespace_list_Helper(Name,Z,X),!.
namespace_list_Helper(Name, List,X) :- namespaces(ID,Name),page(Y,ID,_,_), member(Y,List),append(List,[],X).