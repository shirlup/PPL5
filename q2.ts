// q2.ts

export interface TreeNode {
  children: Tree[];
};

export interface TreeLeaf {
  value: number;
};

export type Tree = TreeNode | TreeLeaf;
export const isTreeNode = (x: any): x is TreeNode => x.children !== undefined;
export const isTreeLeaf = (x: any): x is TreeLeaf => x.value !== undefined;
export const isTree = (x: any): x is Tree => isTreeNode(x) || isTreeLeaf(x);

// Example values:

export const t1: Tree = {value: 5};
export const t2: Tree = {children: [
                   {children: [{value: 1}, {value: 7}, {value: 5}]},
                   {value: 3},
                   {value: 10}]};
export const t3: Tree = {children: [
                   {children: [{value: 20}, {value: 5}, {value: 50}]},
                   {value: 5}]};


export const leftMostEven1 = (atree: Tree): number => {
  
  if(isTreeNode(atree) && atree.children.length == 0) return -1;
  if( isTreeLeaf(atree)){
    if((atree.value)%2 === 0 )
      return atree.value
    else return -1;
  }
  let ansCar = leftMostEven1(atree.children[0]);
  if(ansCar != -1 ) return ansCar;
  else{ 
    let newTree = {children: atree.children.slice(1)};
    return leftMostEven1(newTree);
  }
}
  


export const leftMostEven2 = (atree: Tree): number =>
  leftMostEven$(atree,
                (x) => x,
                () => -1);


const leftMostEven$ = <T1, T2>(atree: Tree,
                               succ: ((x:number) => T1),
                               fail: (() => T2)): (T1 | T2) =>{
if(isTreeNode(atree) && atree.children.length == 0) return fail();
if( isTreeLeaf(atree)){
  if((atree.value)%2 === 0 )
    return succ(atree.value);
  return fail();
}
let newTree = {children: atree.children.slice(1)};
return leftMostEven$(atree.children[0],succ,() => leftMostEven$(newTree,succ,fail));

}    