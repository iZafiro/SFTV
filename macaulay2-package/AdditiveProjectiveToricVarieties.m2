newPackage(
        "AdditiveProjectiveToricVarieties",
        AuxiliaryFiles => true,
        Version => "0.1", 
        Date => "10 December 2022",
        Authors => {
            {Name => "Fabián Levicán", 
                Email => "filevican2@gmail.com"}
            },
        Headline => "methods for additive actions on projective toric varieties",
	Keywords => {"Toric Geometry", "Convex Geometry"},
        PackageImports => {"NormalToricVarieties", "Polyhedra"},
        PackageExports => {"NormalToricVarieties", "Polyhedra"}
        )

export {
    "isAdditive",
    "listAdditiveSmoothFanoToricVarieties",
    "randomAdditiveSmoothFanoToricVariety"
    }

classifier := new List from [];
classifier = append(classifier, {{0, true}});
for d from 2 to 5 do(
    fn := concatenate {currentFileDirectory | "AdditiveProjectiveToricVarieties/classifier", toString d, ".csv"};
    classifier = append(classifier, apply(lines get fn, value));
);

findEdgesFromVertex = (V, edges, i) -> (
    edgesFromVertex := new List from [];
    for j from 0 to #edges - 1 do(
        if member(i, edges#j#0) then (
            otherIndex := (toList(set(edges#j#0) - {i}))#0;
            edge := V_otherIndex - V_i;
            edgesFromVertex = append( edgesFromVertex, (1/gcd(entries edge)) * edge);
        );
    );
    return edgesFromVertex;
);

checkVertex = (d, P, V, H, VF, J, edges, i) -> (
    edgesFromVertex := matrix(findEdgesFromVertex(V, edges, i));
    if (not (numgens source edgesFromVertex == d)) then return false;
    detEdgesFromVertex := det edgesFromVertex;
    if (not (detEdgesFromVertex == 1 or detEdgesFromVertex == -1)) then return false;
    for j from 0 to J - 1 do(
        if (VF_(i,j) == 0) then(
            for k from 0 to numgens source edgesFromVertex - 1 do(
                if ((entries (H^{j} * edgesFromVertex_{k}))#0#0 > 0) then (
                    return false;
                );
            );
        );
    );
    return true;
);

isAdditive = method()
isAdditive(Polyhedron) := (P) -> (
    if (not isCompact P) then error "expected a compact polyhedron (i. e., a polytope)";
    if (not isFullDimensional P) then error "expected a full-dimensional polytope";
    if (not isLatticePolytope P) then error "expected a lattice polytope";
    d := ambDim P;
    if (not isVeryAmple P) then(
        P = (d - 1)*P;
    );
    V := vertices P;
    H := (-1)*(facets P)#0;
    VF := submatrix'((vertexFacetMatrix P), {0}, {0});
    I := numgens target VF;
    J := numgens source VF;
    edges := faces(d - 1, P);
    for i from 0 to I-1 do (
        if checkVertex(d, P, V, H, VF, J, edges, i) then {
            return true;
        };
    );
    return false;
);

isAdditive(NormalToricVariety) := (X) -> (
    if (not isProjective X) then error "expected a projective toric variety";
    V := transpose matrix rays X;
    P := polar convexHull V;
    return isAdditive P;
);

isAdditive(ZZ, ZZ) := (d, n) -> (
    if (d <= 0 or d >= 7) then error "expected d in 1 ... 6";
    if (d == 1 and n != 0) then error "expected n == 0";
    if (d == 2 and (n <= -1 or n >= 5)) then error "expected n in 0 ... 4";
    if (d == 3 and (n <= -1 or n >= 18)) then error "expected n in 0 ... 17";
    if (d == 4 and (n <= -1 or n >= 124)) then error "expected n in 0 ... 123";
    if (d == 5 and (n <= -1 or n >= 866)) then error "expected n in 0 ... 865";
    if d == 6 then return isAdditive smoothFanoToricVariety(d, n);
    return classifier#(d - 1)#(n - 1)#1;
);

listAdditiveSmoothFanoToricVarieties = method()
listAdditiveSmoothFanoToricVarieties(ZZ) := (d) -> (
    if (d <= 0 or d >= 6) then error "expected d in 1 ... 5";
    l := new List from [];
    for x in classifier#(d - 1) do (
        if x#1 then l = append(l, {x#0, smoothFanoToricVariety(d, x#0)});
    );
    return l;
);

randomAdditiveSmoothFanoToricVariety = method()
randomAdditiveSmoothFanoToricVariety(ZZ) := (d) -> (
    if (d <= 0 or d >= 6) then error "expected d in 1 ... 5";
    randomisedClassifier := random classifier#(d - 1);
    i := 0;
    for x in randomisedClassifier when not x#1 do i = i + 1;
    x := randomisedClassifier#i;
    return {x#0, smoothFanoToricVariety(d, x#0)};
)

beginDocumentation()

doc ///
  Key
    AdditiveProjectiveToricVarieties
  Headline
    Methods for additive actions on projective toric varieties
  Description
   Text

     {\bf Overview:}

     {\it AdditiveProjectiveToricVarieties} is a package with various methods for working with additive actions
     on projective toric varieties.

     Let X be an irreducible algebraic variety over an algebraically closed field. An additive action on X is
     an effective regular action of the commutative unipotent group on X with a dense open orbit.

     You can use this package to check if a given projective toric variety admits an additive action. This is done by
     checking if the associated very ample full-dimensional lattice polytope is inscribed in a rectangle (see [1]).
     
     You can also use this package to get lists of additive smooth Fano toric varieties (see the database on @TO NormalToricVarieties@),
     or a random one. A pre-processed database has been included to this effect. There are 4 additive smooth Fano toric surfaces,
     14 threefolds [4], 79 fourfolds, 470 fivefolds, and 3428 sixfolds.

     In the future, you will also be able to use this package to check if this action is unique (up to isomorphism, see [2]),
     and to calculate Demazure roots.

     The package is work in progress, so there will be improvements and more testing.
    
     {\bf References:}

     [1]: Arzhantsev, I. and Romaskevich, E. (2017). Additive actions on toric varieties. Proc. Amer. Math. Soc., 145(5):1865-1879.
     
     [2]: Dzhunusov, S. (2022). On uniqueness of additive actions on complete toric varieties. Journal of Algebra, 609:642-656.
     
     [3]: Hassett, B. and Tschinkel, Y. (1999). Geometry of equivariant compactifications of G_a^n. M2Internat. Math. Res. Notices, (22):1211-1230.

     [4]: Huang, Z. and Montero, P. (2020). Fano threefolds as equivariant compactifications of the vector group. Michigan Math. J., 69(2):341-368.
///

doc ///
  Key
    isAdditive
    (isAdditive,Polyhedron)
    (isAdditive,NormalToricVariety)
    (isAdditive,ZZ,ZZ)
  Headline
    check if a projective toric variety admits an additive action
  Usage
    isAdditive(P)
    isAdditive(X)
    isAdditive(d,n)
  Inputs
    P:Polyhedron
        a full-dimensional lattice polytope associated to the projective toric variety
        (i. e., the normal fan spans the faces of the polar polytope)
    X:NormalToricVariety
        a projective normal toric variety
    d:ZZ
        the dimension (in 1 ... 6)
    n:ZZ
        the index of a smooth Fano toric variety as per the database on the @TO NormalToricVarieties@ package
  Outputs
    :Boolean
        true if the projective toric variety admits an additive action, false if not
  Description
   Text
     Checks if the projective toric variety admits an additive action by checking if the associated
     very ample full-dimensional lattice polytope is inscribed in a rectangle (see [1]).

     If the input is a Polyhedron, the method first verifies that it is compact, full-dimensional, and its vertices lie on the lattice.
     If the polytope is not very ample, it also scales it by d - 1, so that it is, as the algorithm requires it.

     If the input is a NormalToricVariety, the method first verifies that it is projective.

     In either of the previous two cases, the projective toric variety may be of any dimension.

     If the input is (d, n), the method first verifies that the values are valid and, if d <= 5,
     fetches the output from the pre-processed database.

     {\it Warning! For some polytopes of dimension greater than six this method may be slow; this will be fixed in the future.}

     Projective 2-space admits an additive action [3]:
   Example
     PP2 = toricProjectiveSpace 2;
     isAdditive(PP2)
   Text
     The projective variety associated to the polar of the Del Pezzo polygon does not admit an additive action:
   Example
     V = transpose matrix {{1, 0}, {0, 1}, {-1, 0}, {0, -1}, {1, 1}, {-1, -1}};
     P = polar convexHull V;
     isAdditive(P)
///

doc ///
  Key
    listAdditiveSmoothFanoToricVarieties
    (listAdditiveSmoothFanoToricVarieties,ZZ)
  Headline
    generates a list of all additive smooth Fano toric varieties of a given dimension
  Usage
    listAdditiveSmoothFanoToricVarieties(d)
  Inputs
    d:ZZ
        the dimension (in 1 ... 5)
  Outputs
    :List
        containing indices as per the database on the @TO NormalToricVarieties@ package, and the corresponding additive smooth Fano toric varieties as objects of type @TO NormalToricVariety@
  Description
   Text
     The method first checks that d is valid, then fetches the output from the pre-processed database. This method does not currently list sixfolds;
     this will be fixed in the future.

     As an example, the following is the two-dimensional case:
   Example
     listAdditiveSmoothFanoToricVarieties(2)
   Text
     There are 470 additive Smooth fano toric fivefolds:
   Example
     #listAdditiveSmoothFanoToricVarieties(5)
///

doc ///
  Key
    randomAdditiveSmoothFanoToricVariety
    (randomAdditiveSmoothFanoToricVariety,ZZ)
  Headline
    gets a random additive smooth Fano toric variety of a given dimension
  Usage
    randomAdditiveSmoothFanoToricVariety(d)
  Inputs
    d:ZZ
        the dimension (in 1 ... 5)
  Outputs
    :List
        containing an index as per the database on the @TO NormalToricVarieties@ package, and the corresponding additive smooth Fano toric variety as an object of type @TO NormalToricVariety@
  Description
   Text
     The method first checks that d is valid, then fetches the output from the pre-processed database. This method does not currently get sixfolds;
     this will be fixed in the future.

     As an example, the following is a random additive smooth Fano toric threefold:
   Example
     randomAdditiveSmoothFanoToricVariety(3)
///

TEST ///
count = 0;
for i from 0 to 4 do(
    if isAdditive smoothFanoToricVariety(2, i) then(
        count = count + 1;
    );
);
assert(count == 4);
///

TEST ///
count = 0;
for i from 0 to 17 do(
    if isAdditive smoothFanoToricVariety(3, i) then(
        count = count + 1;
    );
);
assert(count == 14);
///

TEST ///
count = 0;
for i from 0 to 123 do(
    if isAdditive smoothFanoToricVariety(4, i) then(
        count = count + 1;
    );
);
assert(count == 79);
///

TEST ///
count = 0;
for i from 0 to 4 do(
    if isAdditive(2, i) then(
        count = count + 1;
    );
);
assert(count == 4);
///

TEST ///
count = 0;
for i from 0 to 17 do(
    if isAdditive(3, i) then(
        count = count + 1;
    );
);
assert(count == 14);
///

TEST ///
count = 0;
for i from 0 to 123 do(
    if isAdditive(4, i) then(
        count = count + 1;
    );
);
assert(count == 79);
///

TEST ///
assert(#listAdditiveSmoothFanoToricVarieties(1) == 1);
assert(#listAdditiveSmoothFanoToricVarieties(2) == 4);
assert(#listAdditiveSmoothFanoToricVarieties(3) == 14);
assert(#listAdditiveSmoothFanoToricVarieties(4) == 79);
assert(#listAdditiveSmoothFanoToricVarieties(5) == 470);
///

TEST ///
assert(isAdditive (randomAdditiveSmoothFanoToricVariety(1))#1);
assert(isAdditive (randomAdditiveSmoothFanoToricVariety(2))#1);
assert(isAdditive (randomAdditiveSmoothFanoToricVariety(3))#1);
assert(isAdditive (randomAdditiveSmoothFanoToricVariety(4))#1);
assert(isAdditive (randomAdditiveSmoothFanoToricVariety(5))#1);
///

end