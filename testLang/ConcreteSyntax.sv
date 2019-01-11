grammar testLang;

terminal Tree_t  'tree' lexer classes {atom_storage_type};
terminal LFork_t 'fork' lexer classes {atom_entity_name_function};
terminal LLeaf_t 'leaf' lexer classes {atom_keyword_control};
terminal RFork_t 'fork' lexer classes {atom_constant_language};
terminal RLeaf_t 'leaf' lexer classes {atom_string_quoted};

terminal Expr_t 'expr' lexer classes {atom_storage_type};
terminal Plus_t '+' precedence=1, association=left, lexer classes {atom_keyword_operator};
terminal Mult_t '*' precedence=2, association=left, lexer classes {atom_keyword_operator};
terminal DecimalNum_t /((0)|([1-9][0-9]*))/ lexer classes {atom_constant_numeric};

terminal LBracket_t '[';
terminal RBracket_t ']';

ignore terminal Whitespace_t /[\ \t\r\n]+/;
ignore terminal Comment_t /[\/][\/].*/ lexer classes {atom_comment_line_doubleSlash};

nonterminal Top_c with pp, altPP;
nonterminal TopItem_c with pp, altPP;

nonterminal Tree_c with pp, altPP;
nonterminal LTree_c with pp, altPP;
nonterminal RTree_c with pp, altPP;

nonterminal ExprStart_c with pp, altPP;
nonterminal Expr_c with pp, altPP;

synthesized attribute pp :: String;
synthesized attribute altPP :: String;

concrete productions
top::Top_c
| i::TopItem_c rest::Top_c
  {
    top.pp = i.pp ++ " " ++ rest.pp;
    top.altPP = i.altPP ++ " " ++ rest.altPP;
  }
| i :: TopItem_c
  {
    top.pp = i.pp;
    top.altPP = i.altPP;
  }

concrete productions
top::TopItem_c
| tree::Tree_c
  {
    top.pp = tree.pp;
    top.altPP = tree.altPP;
  }
| expr::ExprStart_c
  {
    top.pp = expr.pp;
    top.altPP = expr.altPP;
  }

concrete productions
top::Tree_c
| t::Tree_t l::LBracket_t tree::LTree_c r::RBracket_t
  {
    top.pp = t.lexeme ++ " " ++ l.lexeme ++ " " ++ tree.pp ++ " " ++ r.lexeme;
    top.altPP = "tree [" ++ tree.altPP ++ "]";
  }


concrete productions
top::LTree_c
| f::LFork_t  l::LTree_c  r::RTree_c
  {
    top.pp = f.lexeme ++ " " ++ l.pp ++ " " ++ r.pp;
    top.altPP = "lfork " ++ l.altPP ++ " " ++ r.altPP;
  }
| lf::LLeaf_t
  {
    top.pp = lf.lexeme;
    top.altPP = "lleaf";
  }

concrete productions
top::RTree_c
| f::RFork_t  l::LTree_c  r::RTree_c
  {
    top.pp = f.lexeme ++ " " ++ l.pp ++ " " ++ r.pp;
    top.altPP = "rfork " ++ l.altPP ++ " " ++ r.altPP;
  }
| lf::RLeaf_t
  {
    top.pp = lf.lexeme;
    top.altPP = "rleaf";
  }

concrete productions
top::ExprStart_c
| e::Expr_t l::LBracket_t expr::Expr_c r::RBracket_t
  {
    top.pp = e.lexeme ++ " "++ l.lexeme ++ " "++ expr.pp ++ " " ++ r.lexeme;
    top.altPP = "expr [ " ++ expr.altPP ++ " ]";
  }

concrete productions
top::Expr_c
| left::Expr_c op::Plus_t right::Expr_c
  {
    top.pp = left.pp ++ " " ++ op.lexeme ++ " " ++ right.pp;
    top.altPP = left.altPP ++ " + " ++ right.altPP;
  }
| left::Expr_c op::Mult_t right::Expr_c
  {
    top.pp = left.pp ++ " " ++ op.lexeme ++ " " ++ right.pp;
    top.altPP = left.altPP ++ " * " ++ right.altPP;
  }
| num::DecimalNum_t
  {
    top.pp = num.lexeme;
    top.altPP = num.lexeme;
  }
