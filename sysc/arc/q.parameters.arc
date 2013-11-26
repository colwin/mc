.//============================================================================
.// $RCSfile: q.parameters.arc,v $
.//
.// Description:
.// Here we deal with parameters.  The declaration, definition and invocation
.// renderings are built.
.//
.// Notice:
.// (C) Copyright 1998-2011 Mentor Graphics Corporation
.//     All rights reserved.
.//
.// This document contains confidential and proprietary information and
.// property of Mentor Graphics Corp.  No part of this document may be
.// reproduced without the express written permission of Mentor Graphics Corp.
.//============================================================================
.//
.//
.function te_parm_RenderParameters
  .param inst_ref_set te_parms
  .// Consider that we may have additional parameters (like for passing "self").
  .assign defn = " void"
  .assign decl = " void"
  .assign invo = ""
  .assign stru = ""
  .assign assn = ""
  .assign assnbase = ""
  .assign param_delimiter = " "
  .assign item_number = 0
  .assign item_count = cardinality te_parms
  .if ( 0 < item_count )
    .invoke SortSetAlphabeticallyByNameAttr( te_parms )
    .select any previous_te_parm from instances of TE_PARM where ( false )
    .assign defn = ""
    .assign decl = ""
    .while ( item_number < item_count )
      .for each te_parm in te_parms
        .if ( te_parm.Order == item_number )
          .// Link te_parms together in sequence.
          .if ( not_empty previous_te_parm )
            .// relate previous_te_parm to te_parm across R2041.'succeeds';
            .assign previous_te_parm.nextID = te_parm.ID
          .end if
          .assign previous_te_parm = te_parm
          .select one te_dt related by te_parm->TE_DT[R2049]
          .assign te_dt.Included = true
          .assign param_qual = ""
          .if ( 0 != te_parm.By_Ref )
            .assign param_qual = param_qual + " *"
          .end if
          .assign defn = ( ( defn + param_delimiter ) + ( te_dt.ExtName + param_qual ) ) + ( ( " " + te_parm.GeneratedName ) + te_parm.array_spec )
          .assign decl = ( ( decl + param_delimiter ) + ( te_dt.ExtName + param_qual ) ) + te_parm.array_spec
          .assign invo = ( invo + param_delimiter ) + te_parm.GeneratedName
          .assign stru = ( ( stru + te_dt.ExtName ) + ( param_qual + " " ) ) + ( ( te_parm.GeneratedName + te_parm.array_spec ) + ";\n" )
          .invoke s = t_oal_smt_event_parameters( "", te_parm.Name, te_parm.GeneratedName, te_dt.Core_Typ, "  " )
          .assign assn = assn + s.result
          .if ( "A00portindex" != "${te_parm.Name}" )
            .assign assnbase = assnbase + s.result
          .end if
          .assign param_delimiter = ", "
          .break for
        .end if
      .end for
      .assign item_number = item_number + 1
    .end while
  .end if
  .assign attr_definition = defn + " "
  .assign attr_declaration = decl + " "
  .assign attr_invocation = invo
  .assign attr_structure = stru
  .assign attr_assignment = assn
  .assign attr_assignment_base = assnbase
.end function
.//