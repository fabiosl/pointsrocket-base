#= require "./lib/datatables/js/jquery.dataTables.js"
#= require "./lib/datatables/tabletools/js/dataTables.tableTools.js"
#= require "./lib/datatables/js/datatables-bs3.js"
#= require "./lib/jquery.fixedheadertable.js"

$('.data-table').dataTable()
$('.most-recognized-table').dataTable({
  "paging": false,
  "ordering": false,
  "searching": false
})
$('.top-hashtags-table').dataTable({
  "ordering": false
})
$('.fixed-header-table').each ->
  $this = $(this)
  $this.parent().height( $this.height() + 20 );
  setTimeout ->
    $this.fixedHeaderTable({ footer: false, cloneHeadToFoot: false, fixedColumn: true });
  , 200

