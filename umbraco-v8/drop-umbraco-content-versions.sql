/* Drop Umbraco Content Versions */
/* Last updated: 13th May 2023 */
/* Source: https://our.umbraco.com/forum/umbraco-8/96498-delete-old-versions */

DECLARE @toDate AS Date = '2008-01-01';
DECLARE @nodeId AS INT;

SELECT cv.id
INTO #toDelete
FROM umbracoDocumentVersion dv
INNER JOIN umbracoContentVersion cv ON dv.id = cv.id
WHERE cv.nodeId = @nodeId AND cv.[current] != 1 AND dv.published != 1 AND cv.VersionDate < @toDate

DELETE FROM umbracoPropertyData WHERE versionId IN (select id from #toDelete)
DELETE FROM umbracoDocumentVersion WHERE id IN (select id from #toDelete)
DELETE FROM umbracoContentVersionCultureVariation WHERE versionId IN (select id from #toDelete)
DELETE FROM umbracoContentVersion WHERE id IN (select id from #toDelete)

DROP TABLE #toDelete

DELETE FROM [dbo].[umbracoLog] WHERE DateStamp < @toDate