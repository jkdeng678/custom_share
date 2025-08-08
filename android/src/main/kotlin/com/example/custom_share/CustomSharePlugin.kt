package com.example.custom_share

import android.content.Intent
import android.util.Log
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

/** CustomSharePlugin */
class CustomSharePlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel: MethodChannel
  private lateinit var applicationContext: android.content.Context
  private var activity: android.app.Activity? = null
  private val TAG = "CustomSharePlugin"

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "custom_share")
    channel.setMethodCallHandler(this)
    applicationContext = flutterPluginBinding.applicationContext
    Log.d(TAG, "Attached to engine, applicationContext initialized")
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    Log.d(TAG, "Attached to activity: ${activity?.javaClass?.simpleName}")
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
    Log.d(TAG, "Detached from activity for config changes")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
    Log.d(TAG, "Reattached to activity: ${activity?.javaClass?.simpleName}")
  }

  override fun onDetachedFromActivity() {
    activity = null
    Log.d(TAG, "Detached from activity")
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    val context = activity ?: applicationContext
    Log.d(TAG, "Method call: ${call.method}, using context: ${context.javaClass.simpleName}")

    when (call.method) {
      "shareText" -> {
        val text = call.argument<String>("text")
        if (text == null) {
          result.error("INVALID_ARGUMENT", "Text cannot be null", null)
          return
        }
        try {
          val intent = Intent(Intent.ACTION_SEND).apply {
            type = "text/plain"
            putExtra(Intent.EXTRA_TEXT, text)
            if (context == applicationContext) {
              addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
              Log.d(TAG, "Added FLAG_ACTIVITY_NEW_TASK for shareText")
            }
          }
          val chooser = Intent.createChooser(intent, "Share Text")
          context.startActivity(chooser)
          Log.d(TAG, "Started shareText activity")
          result.success("success")
        } catch (e: Exception) {
          Log.e(TAG, "Failed to share text", e)
          result.error("SHARE_FAILED", "Failed to share text: ${e.message}", null)
        }
      }
      "shareFile" -> {
        val filePath = call.argument<String>("filePath")
        val mimeType = call.argument<String>("mimeType") ?: "*/*"
        if (filePath == null) {
          result.error("INVALID_ARGUMENT", "File path cannot be null", null)
          return
        }
        try {
          val file = File(filePath)
          Log.d(TAG, "Sharing file: $filePath, exists: ${file.exists()}, MIME: $mimeType")
          if (!file.exists()) {
            result.error("FILE_NOT_FOUND", "File does not exist: $filePath", null)
            return
          }
          val uri = FileProvider.getUriForFile(
            context,
            "${applicationContext.packageName}.fileprovider",
            file
          )
          Log.d(TAG, "FileProvider URI: $uri")
          val intent = Intent(Intent.ACTION_SEND).apply {
            type = mimeType
            putExtra(Intent.EXTRA_STREAM, uri)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            if (context == applicationContext) {
              addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
              Log.d(TAG, "Added FLAG_ACTIVITY_NEW_TASK for shareFile")
            }
          }
          val chooser = Intent.createChooser(intent, "Share File")
          context.startActivity(chooser)
          Log.d(TAG, "Started shareFile activity")
          result.success("success")
        } catch (e: Exception) {
          Log.e(TAG, "Failed to share file", e)
          result.error("SHARE_FAILED", "Failed to share file: ${e.message}", null)
        }
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    Log.d(TAG, "Detached from engine")
  }
}